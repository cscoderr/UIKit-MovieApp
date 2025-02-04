//
//  ShadowCardView.swift
//  MovieApp
//
//  Created by Tomiwa Idowu on 2/3/25.
//

import UIKit

class ShadowCardView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.1
        layer.shadowOffset = .zero
        layer.cornerRadius = 15
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}
