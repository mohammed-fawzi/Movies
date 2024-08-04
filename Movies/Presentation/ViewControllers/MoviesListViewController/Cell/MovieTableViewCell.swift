//
//  MovieTableViewCell.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import UIKit
import DomainLayer

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var imageLoader: ImageLoaderProtocol = ImageLoader.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        releaseDate.text = nil
        scoreLabel.text = nil
        posterImageView.image = nil
    }
    
    func configureCell(withMovie movie: Movie){
        titleLabel.text = movie.title
        scoreLabel.text = String(format: "%.1f", movie.score ?? "")
        releaseDate.text = movie.releaseDate
        guard let posterUrl = movie.posterUrl else {return}
        imageLoader.loadImage(from: posterUrl){[weak self] image in
            DispatchQueue.main.async {
                self?.showImage(image: image)
            }
        }
    }
}

extension MovieTableViewCell {
    private func showImage(image: UIImage?) {
        posterImageView.image = image ?? .posterPlaceholderSm
        }
}
