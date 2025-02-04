//
//  CircularProgressBarView.swift
//  MovieApp
//
//  Created by Tomiwa Idowu on 2/1/25.
//

import UIKit

class CircularProgressBarView: UIView {
    
    private var trackLayer: CAShapeLayer!
    private var progressLayer: CAShapeLayer!
    private var label: UILabel!
    
    var progress: CGFloat = 0 {
        didSet {
            progressLayer.strokeEnd = progress
            updateLabel()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        // Create circular track
        trackLayer = CAShapeLayer()
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        
        // Create progress circle
        progressLayer = CAShapeLayer()
        progressLayer.strokeColor = UIColor.blue.cgColor // Progress color
        progressLayer.lineWidth = 10
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeEnd = 0
        
        // Add layers to the view's layer
        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)
        
        // Create and add label in the center
        label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Create the circular path
        let radius = min(bounds.width, bounds.height) / 2 - trackLayer.lineWidth / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi - CGFloat.pi / 2, clockwise: true)
        
        // Set the path for track and progress layers
        trackLayer.path = path.cgPath
        progressLayer.path = path.cgPath
        
        // Set label frame
        label.frame = bounds
    }
    
    private func updateLabel() {
        label.text = "\(Int(progress * 100))%" // Show progress percentage
    }
}

