//
//  DrillSetupViewController.swift
//  PoolDrills
//
//  Created by Marius on 2020-03-27.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class DrillSetupViewController: UITableViewController {

    lazy var drill: Drill = {
        return Drill(context: coredata.managedContext)
    }()

    private let coredata = CoreDataStack()

    @IBOutlet private weak var titleField: UITextField!
    @IBOutlet private weak var attemptsSlider: CustomUISlider!
    @IBOutlet private weak var durationSlider: CustomUISlider!

    override func viewDidLoad() {
        super.viewDidLoad()

        attemptsSlider.font = titleField.font
        durationSlider.font = titleField.font

        titleField.text = drill.title
        attemptsSlider.value = Float(drill.attempts)
        durationSlider.value = Float(drill.duration / 60)
    }

    @IBAction private func cancelButtonDidTap(_ sender: UIBarButtonItem) {
        coredata.managedContext.rollback()

        navigationController?.popViewController(animated: true)
    }

    @IBAction private func saveButtonDidTap(_ sender: UIBarButtonItem) {
        drill.title = titleField.text
        drill.attempts = Int32(attemptsSlider.value)
        drill.duration = Double(durationSlider.value).rounded(.up) * 60

        coredata.saveContext()

        navigationController?.popViewController(animated: true)
    }

    @IBAction private func attemptsSliderDidChangeValue(_ sender: CustomUISlider) {
        sender.valueLabel.text = String(Int(sender.value))
    }

    @IBAction private func durationSliderDidChangeValue(_ sender: CustomUISlider) {
        sender.valueLabel.text = String("\(Int(sender.value)) min")
    }

}
