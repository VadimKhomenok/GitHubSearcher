//
//  GradientTransparencyView.swift
//  GitHubSearcher
//
//  Created by Vadim Khomenok on 17.09.21.
//

import UIKit

class GradientTransparencyView: UIView {
    var gradientColor: UIColor = UIColor.white
    private var gradient = CAGradientLayer()
    
    override func draw(_ rect: CGRect) {
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.colors = [gradientColor.withAlphaComponent(1.0).cgColor,
                           gradientColor.withAlphaComponent(0.6).cgColor,
                           gradientColor.withAlphaComponent(0.0).cgColor]
        gradient.locations = [NSNumber(value: 0.0),
                              NSNumber(value: 0.7),
                              NSNumber(value: 1.0)]
        gradient.frame = bounds
        layer.mask = gradient
    }
}
