//
//  RoutinesViewCell.swift
//  PoolDrills
//
//  Created by Marius on 2020-04-16.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

protocol RoutineCellRunButtonDelegate: AnyObject {
    func routineRunButtonDidTap(_ button: UIButton, inside cell: UITableViewCell)
}

final class RoutineCell: CustomSelectedBackgroundCell {

    weak var delegate: RoutineCellRunButtonDelegate?

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var runButton: UIButton!

    override func prepareForReuse() {
        super.prepareForReuse()

        delegate = nil
    }

    @IBAction private func runButtonDidTap(_ sender: UIButton) {
        delegate?.routineRunButtonDidTap(sender, inside: self)
    }

}
