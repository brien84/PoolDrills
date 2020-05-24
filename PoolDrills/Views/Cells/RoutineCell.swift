//
//  RoutinesViewCell.swift
//  PoolDrills
//
//  Created by Marius on 2020-04-16.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

protocol RoutineRunButtonDelegate: AnyObject {
    func routineRunButtonDidTap(_ button: UIButton, inside cell: UITableViewCell)
}

final class RoutineCell: CustomSelectedBackgroundCell {

    weak var delegate: RoutineRunButtonDelegate?

    @IBOutlet weak var title: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()

        delegate = nil
    }

    @IBAction private func runButtonTapped(_ sender: UIButton) {
        delegate?.routineRunButtonDidTap(sender, inside: self)
    }

}
