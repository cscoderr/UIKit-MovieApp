//
//  MoviesCollectionViewCell.swift
//  MovieApp
//
//  Created by Tomiwa Idowu on 2/1/25.
//

import UIKit
import Kingfisher
import Hero

class MoviesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: MoviesCollectionViewCell.self)

    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var movieContainerView: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieProgressLabel: UILabel!
    
    func setup(movie: Movie) {
        movieTitleLabel.text = movie.title ?? movie.name
        movieImageView.kf.indicatorType = .activity
        movieImageView.kf.setImage(with: movie.imageUrl, options: [.transition(.fade(0.3))])
        UIView.animate(withDuration: 0.3) {
            self.movieProgressLabel.text = "\(String(format: "%.0f", (movie.voteAverage * 10).rounded()))%"
            self.layoutIfNeeded()
        }
    }
    
    func hideTitleLabel() {
        movieTitleLabel.isHidden = true
        imageContainer.bottomAnchor
            .constraint(
                equalTo: movieContainerView.bottomAnchor,
                constant: -20
            ).isActive = true
    }
    
    func setupConstraints() {
        movieContainerView.widthAnchor
            .constraint(equalToConstant: 150).isActive = true
        movieImageView.heightAnchor
            .constraint(equalToConstant: 250).isActive = true
    }

}
