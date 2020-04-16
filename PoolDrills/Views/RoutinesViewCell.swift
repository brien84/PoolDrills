//
//  RoutinesViewCell.swift
//  PoolDrills
//
//  Created by Marius on 2020-04-16.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

protocol RoutineRunButtonDelegate: AnyObject {
    func routineRunButtonDidTap(inside cell: UITableViewCell)
}

final class RoutinesViewCell: UITableViewCell {

    weak var delegate: RoutineRunButtonDelegate?

    @IBAction private func runButtonTapped(_ sender: UIButton) {
        delegate?.routineRunButtonDidTap(inside: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    override func prepareForReuse() {
        super.prepareForReuse()

        delegate = nil
    }

}
