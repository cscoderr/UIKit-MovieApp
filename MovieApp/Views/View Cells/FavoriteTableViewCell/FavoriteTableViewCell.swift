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
    
    func setup(favorite: Favorite) {
        favoriteTitleLabel.text = favorite.title ?? favorite.name
        favoriteDescriptionLabel.text = favorite.overview ?? ""
        favoriteRatingLabel.text = String(favorite.voteAverage)
        favoriteImageView?.kf
            .setImage(
                with: favorite.imageUrl
            )
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
