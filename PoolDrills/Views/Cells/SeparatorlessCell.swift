//
//  NoSeparatorCell.swift
//  PoolDrills
//
//  Created by Marius on 2020-05-28.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class SeparatorlessCell: UITableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()

        for view in subviews where view != contentView {
            view.removeFromSuperview()
        }
    }

}
