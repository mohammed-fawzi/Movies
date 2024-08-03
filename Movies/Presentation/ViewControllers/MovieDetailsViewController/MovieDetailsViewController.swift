//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import UIKit
import Combine

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var tagsView: TagsCollectionView!
    
     var viewModel: MovieDetailsViewModel?
    private var subscriptions = Set<AnyCancellable>()
    private var imageLoader: ImageLoaderProtocol = ImageLoader.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel?.viewDidLoad()
    }
    
    @IBAction func HomePageButtonTapped(_ sender: UIButton) {
        viewModel?.homePageButtonDidTapped()
    }
}

// MARK: - Binding
extension MovieDetailsViewController {
    func bind(){
        bindViews()
        bindActions()
    }
    
    private func bindViews(){
        guard let viewModel = viewModel else {return}
        
        viewModel.$title
            .receive(on: RunLoop.main)
            .assign(to: \.text!, on: titleLabel)
            .store(in: &subscriptions)
        
        viewModel.$genres
            .receive(on: RunLoop.main)
            .assign(to: \.text!, on: genresLabel)
            .store(in: &subscriptions)
        
        viewModel.$overview
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
            self?.overviewTextView.text = text
        }.store(in: &subscriptions)
        
        viewModel.$poster
            .receive(on: RunLoop.main)
            .sink { [weak self] imageUrl in
            self?.imageLoader.loadImage(from: imageUrl){[weak self] image in
                self?.posterImageView.image = image
            }
        }.store(in: &subscriptions)
        
        viewModel.$tags
            .receive(on: RunLoop.main)
            .sink { [weak self] tags in
            self?.tagsView.tags = tags.map({ (name, icon, iconColor) in
                let icon = icon != nil ? UIImage(systemName: icon!) : nil
                let color = iconColor != nil ? UIColor(named: iconColor!) : nil
                return Tag(id: 0, name: name, icon: icon, iconColor: color)
            })
        }.store(in: &subscriptions)
    }
    
    private func bindActions(){
        viewModel?.$errorMessage
            .receive(on: RunLoop.main)
            .sink{ [weak self] message in
                guard !message.isEmpty else {return}
                self?.showAlert(withTitle: "Error!", andErrorMessage: message)
        }.store(in: &subscriptions)
    }
}
