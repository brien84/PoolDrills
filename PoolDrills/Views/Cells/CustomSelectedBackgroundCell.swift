//
//  CustomSelectedBackgroundCell.swift
//  PoolDrills
//
//  Created by Marius on 2020-05-23.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

class CustomSelectedBackgroundCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()

        let view = UIView()
        view.backgroundColor = .secondaryBackground
        selectedBackgroundView = view

        if #available(iOS 13.0, *) {
            tintColor = .secondaryBackground
        } else {
            tintColor = .lightElement
        }
    }

}
