//
//  MoviesListViewController.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import UIKit
import Combine

class MoviesListViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var emptyStateView: EmptyStateView!
    @IBOutlet weak var filtersView: TagsCollectionView!
    
    // MARK: -Properties
    let cellID = "MovieTableViewCell"
    let footerSpinner = UIActivityIndicatorView(style: .medium)
    let refreshControl = UIRefreshControl()
    var viewModel: MoviesListViewModelProtocol?
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.title = tabBarItem.title
    }
    
    @objc func refresh(_ sender: AnyObject) {
        viewModel?.refresh()
    }
}

// MARK: - UI Setup
extension MoviesListViewController {
    private func setupUI(){
        setupTableView()
        setupFooterSpinner()
        setupSearchBar()
        setupRefreshControl()
    }
    
    private func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = footerSpinner
        let nib = UINib(nibName: cellID, bundle: .main)
        tableView.register( nib , forCellReuseIdentifier: cellID)
    }
    
    private func setupFooterSpinner(){
        footerSpinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        footerSpinner.color = .white
        footerSpinner.style = .medium
        footerSpinner.hidesWhenStopped = true
    }
    
    private func setupRefreshControl(){
        let colorAtrribute = [NSAttributedString.Key.foregroundColor : UIColor.white]
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh",attributes: colorAtrribute )
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .white
        tableView.addSubview(refreshControl)
    }
    
    private func setupSearchBar(){
        searchBar.delegate = self
        searchBar.searchTextField.textColor = .textPrimary
    }
}

// MARK: - DataSource
extension MoviesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.getNumberOfMovies() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? MovieTableViewCell
        guard let movie = viewModel?.getMovie(atIndex: indexPath.row) else {return UITableViewCell()}
        cell?.configureCell(withMovie: movie)
        return cell ?? UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel?.willShowCell(atIndex: indexPath.row)
    }
}

// MARK: - Delegate
extension MoviesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectCell(atIndex: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Binding
extension MoviesListViewController {
    private func bind(){
        viewModel?.reloadTable
            .receive(on: RunLoop.main)
            .sink {[weak self] _ in
                self?.refreshControl.endRefreshing()
                self?.emptyStateView.isHidden = true
                self?.tableView.reloadData()
            }.store(in: &subscriptions)
        
        viewModel?.showFooterActivityIndicator
            .receive(on: RunLoop.main)
            .sink{ [weak self] show in
            show ? self?.footerSpinner.startAnimating() : self?.footerSpinner.stopAnimating()
        }.store(in: &subscriptions)
        
        viewModel?.showErrorAlert
            .receive(on: RunLoop.main)
            .sink{ [weak self] message in
                self?.showAlert(withTitle: "Error!", andErrorMessage: message)
            }.store(in: &subscriptions)
        
        viewModel?.showEmptyState
            .receive(on: RunLoop.main)
            .sink{ [weak self] _ in
                self?.showEmptyState()
            }.store(in: &subscriptions)
        
        viewModel?.showGenreFilters
            .receive(on: RunLoop.main)
            .sink{ [weak self] tags in
                self?.filtersView.tags = tags
            }.store(in: &subscriptions)
    }
}

extension MoviesListViewController {
    private func showEmptyState(){
        emptyStateView.isHidden = false
        emptyStateView.tryAgainAction = viewModel?.tryAgainButtonDidTapped
    }
}

// MARK: - Search
extension MoviesListViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {return}
        viewModel?.searchButtonDidTapped(withText: text)
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.cancelSearchButtonDidTapped()
        searchBar.resignFirstResponder()
    }
}
