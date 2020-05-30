//
//  GradientBackgroundView.swift
//  PoolDrills
//
//  Created by Marius on 2020-05-19.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class GradientBackgroundView: UIView {

    private var startColor: UIColor? {
        didSet { gradientLayer.colors = cgColorGradient }
    }

    private var endColor: UIColor? {
        didSet { gradientLayer.colors = cgColorGradient }
    }

    private var startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0) {
        didSet { gradientLayer.startPoint = startPoint }
    }

    private var endPoint: CGPoint = CGPoint(x: 1.0, y: 1.0) {
        didSet { gradientLayer.endPoint = endPoint }
    }

    private var gradientLayer: CAGradientLayer {
        // swiftlint:disable:next force_cast
        return layer as! CAGradientLayer
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    convenience init(_ frame: CGRect, _ startColor: UIColor, _ endColor: UIColor, _ startPoint: CGPoint, _ endPoint: CGPoint) {
        self.init(frame: frame)

        commonInit(startColor, endColor, startPoint, endPoint)
    }

    private func commonInit(_ startColor: UIColor = .primaryBackground,
                            _ endColor: UIColor = .secondaryBackground,
                            _ startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0),
                            _ endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)) {

        self.startColor = startColor
        self.endColor = endColor
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}

extension GradientBackgroundView {
    private var cgColorGradient: [CGColor]? {
        guard let startColor = startColor, let endColor = endColor else {
            return nil
        }

        return [startColor.cgColor, endColor.cgColor]
    }
}
