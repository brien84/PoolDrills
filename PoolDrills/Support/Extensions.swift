//
//  Extensions.swift
//  PoolDrills
//
//  Created by Marius on 2020-05-23.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

extension TimeInterval {
    var digitalFormat: String {
        let hours = Int(self) / 3600
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60

        if hours > 0 {
            return String(format: "%02d:%02d:%02d", arguments: [hours, minutes, seconds])
        } else {
            return String(format: "%02d:%02d", arguments: [minutes, seconds])
        }
    }
}

extension UIButton {
    @IBInspectable
    public var adjustsFontForContentSizeCategory: Bool {
        get {
            return self.titleLabel?.adjustsFontForContentSizeCategory ?? false
        }

        set {
            self.titleLabel?.adjustsFontForContentSizeCategory = newValue
        }
    }

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        self.setNeedsLayout()
    }
}

extension UIColor {
    static var primaryBackground: UIColor! {
        return UIColor(named: "primaryBackground")
    }

    static var secondaryBackground: UIColor! {
        return UIColor(named: "secondaryBackground")
    }

    static var darkElement: UIColor! {
        return UIColor(named: "darkElement")
    }

    static var grayElement: UIColor! {
        return UIColor(named: "grayElement")
    }

    static var lightElement: UIColor! {
        return UIColor(named: "lightElement")
    }
}

extension UIImage {
    static var next64: UIImage! {
        return UIImage(named: "next_64")
    }

    static var pause64: UIImage! {
        return UIImage(named: "pause_64")
    }

    static var play64: UIImage! {
        return UIImage(named: "play_64")
    }

    static var one64: UIImage! {
        return UIImage(named: "one_64")
    }

    static var two64: UIImage! {
        return UIImage(named: "two_64")
    }

    static var three64: UIImage! {
        return UIImage(named: "three_64")
    }
}
