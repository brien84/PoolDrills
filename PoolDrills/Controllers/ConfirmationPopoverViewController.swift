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

    private init(_ vc: UIViewController, _ sourceView: UIView?, _ barButtonItem: UIBarButtonItem?) {
        self.presentingVC = vc
        self.sourceView = sourceView
        self.barButtonItem = barButtonItem

        super.init(nibName: "ConfirmationPopoverView", bundle: nil)

        loadViewIfNeeded()
    }

    convenience init(in viewController: UIViewController, on sourceView: UIView) {
        self.init(viewController, sourceView, nil)
    }

    convenience init(in viewController: UIViewController, on barButtonItem: UIBarButtonItem) {
        self.init(viewController, nil, barButtonItem)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        modalPresentationStyle = .popover
        preferredContentSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }

    func present(_ confirmationHandler: @escaping (Bool) -> Void) {
        let popover = popoverPresentationController

        popover?.delegate = self
        popover?.sourceView = sourceView
        popover?.sourceRect = sourceView?.bounds ?? CGRect()
        popover?.barButtonItem = barButtonItem
        popover?.permittedArrowDirections = [.down, .up]

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

extension ConfirmationPopoverViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
