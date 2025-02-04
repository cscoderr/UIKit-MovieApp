//
//  CastCollectionViewCell.swift
//  MovieApp
//
//  Created by Tomiwa Idowu on 2/3/25.
//

import UIKit
import Kingfisher

class CastCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: CastCollectionViewCell.self)
    
    @IBOutlet weak var actorNameLabel: UILabel!
    @IBOutlet weak var actorImageView: UIImageView!
    @IBOutlet weak var actorCharacterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        actorImageView.layer.cornerRadius = 15
        actorImageView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        actorImageView.layer.masksToBounds = true
    }
    
    func setup(cast: Cast) {
        if let profileImageUrl = cast.profileImageUrl {
            actorImageView.kf.setImage(with: profileImageUrl)
        }
        
        actorNameLabel.text = cast.originalName
        actorCharacterLabel.text = cast.character
    }

}
