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

    func countdown(completion: @escaping () -> Void) {
        isUserInteractionEnabled = false

        setImage(.three64, for: .normal)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.setImage(.two64, for: .normal)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.setImage(.one64, for: .normal)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.isUserInteractionEnabled = true
            completion()
        }
    }

}
