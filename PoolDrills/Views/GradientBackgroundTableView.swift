//
//  GradientBackgroundTableView.swift
//  PoolDrills
//
//  Created by Marius on 2020-05-30.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class GradientBackgroundTableView: UITableView {

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        let background = GradientBackgroundView(frame: self.frame)
        backgroundView = background
    }

}
