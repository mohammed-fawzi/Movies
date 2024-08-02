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
    
    // MARK: -Properties
    let cellID = "MovieTableViewCell"
    let footerSpinner = UIActivityIndicatorView(style: .medium)
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
    
}

// MARK: - UI Setup
extension MoviesListViewController {
    private func setupUI(){
        setupTableView()
        setupFooterSpinner()
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
        
    }
}

