//
//  ActionButton.swift
//  PoolDrills
//
//  Created by Marius on 2020-05-26.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

enum ActionButtonImage {
    case next
    case pause
    case play
}

final class ActionButton: UIButton {

    func set(image: ActionButtonImage) {
        switch image {
        case .next:
            setImage(.next64, for: .normal)
        case .pause:
            setImage(.pause64, for: .normal)
        case .play:
            setImage(.play64, for: .normal)
        }
    }

}
