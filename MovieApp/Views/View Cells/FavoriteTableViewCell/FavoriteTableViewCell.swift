//
//  FavoriteTableViewCell.swift
//  MovieApp
//
//  Created by Tomiwa Idowu on 2/1/25.
//

import UIKit
import Kingfisher

class FavoriteTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: FavoriteTableViewCell.self)

    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var favoriteTitleLabel: UILabel!
    @IBOutlet weak var favoriteDescriptionLabel: UILabel!
    @IBOutlet weak var favoriteDateLabel: UILabel!
    @IBOutlet weak var favoriteRatingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(movie: Movie) {
        favoriteTitleLabel.text = movie.title ?? movie.name
        favoriteImageView?.kf
            .setImage(with: movie.imageUrl)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
