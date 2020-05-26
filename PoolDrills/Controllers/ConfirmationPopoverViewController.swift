//
//  ConfirmationPopoverViewController.swift
//  PoolDrills
//
//  Created by Marius on 2020-05-25.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class ConfirmationPopoverViewController: UIViewController {

    private let presentingVC: UIViewController
    private var sourceView: UIView?
    private var barButtonItem: UIBarButtonItem?

    private var confirmationHandler: ((Bool) -> Void)?

    init(in viewController: UIViewController, on sourceView: UIView) {
        self.presentingVC = viewController
        self.sourceView = sourceView
        super.init(nibName: "ConfirmationPopoverView", bundle: nil)

        loadViewIfNeeded()
    }

    init(in viewController: UIViewController, on barButtonItem: UIBarButtonItem) {
        self.presentingVC = viewController
        self.barButtonItem = barButtonItem
        super.init(nibName: "ConfirmationPopoverView", bundle: nil)

        loadViewIfNeeded()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        modalPresentationStyle = .popover
        preferredContentSize = calculateSize()
    }

    func present(_ confirmationHandler: @escaping (Bool) -> Void) {
        let popover = popoverPresentationController

        popover?.delegate = self
        popover?.sourceView = sourceView
        popover?.sourceRect = sourceView?.bounds ?? CGRect()
        popover?.barButtonItem = barButtonItem

        presentingVC.present(self, animated: true)

        self.confirmationHandler = confirmationHandler
    }

    @IBAction private func denyButtonDidTap(_ sender: UIButton) {
        confirmationHandler?(false)
        self.dismiss(animated: true)
    }

    @IBAction private func confirmButtonDidTap(_ sender: UIButton) {
        confirmationHandler?(true)
        self.dismiss(animated: true)
    }
}

extension ConfirmationPopoverViewController {
    private var presetingVCWidth: CGFloat {
        return presentingVC.view.frame.width
    }

    private var presetingVCHeight: CGFloat {
        return presentingVC.view.frame.height
    }

    private func calculateSize() -> CGSize {
        if (presetingVCHeight / presetingVCWidth) > 1.5 {
            return CGSize(width: presetingVCHeight / 6, height: presetingVCWidth / 6)
        } else {
            return CGSize(width: presetingVCHeight / 8, height: presetingVCWidth / 10)
        }
    }
}

extension ConfirmationPopoverViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
