//
//  DrillQueueViewCell.swift
//  PoolDrills
//
//  Created by Marius on 2020-05-18.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class DrillQueueViewCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var attempts: UILabel!

    override func awakeFromNib() {
        layer.masksToBounds = true
        layer.borderColor = UIColor.lightElement.cgColor
        layer.borderWidth = 2.0
        layer.cornerRadius = 20
    }

}
