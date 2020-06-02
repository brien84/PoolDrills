//
//  ProgressLabelSlider.swift
//  PoolDrills
//
//  Created by Marius on 2020-05-21.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class ProgressLabelSlider: UISlider {

    var font: UIFont? {
        didSet { valueLabel.font = font }
    }

    lazy var valueLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .center
        label.textColor = minimumTrackTintColor
        label.adjustsFontForContentSizeCategory = true

        addSubview(label)

        return label
    }()

    private var labelFrame: CGRect {
        return CGRect(x: thumbRect.midX - thumbRect.width * 2,
                      y: thumbRect.minY - thumbRect.height,
                      width: thumbRect.width * 4,
                      height: thumbRect.height)
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)

        valueLabel.frame = labelFrame
        valueLabel.isHidden = false

        return true
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)

        valueLabel.frame = labelFrame

        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)

        valueLabel.isHidden = true
    }

}

extension ProgressLabelSlider {
    private var trackRect: CGRect {
        return trackRect(forBounds: bounds)
    }

    private var thumbRect: CGRect {
        return thumbRect(forBounds: bounds, trackRect: trackRect, value: value)
    }
}
