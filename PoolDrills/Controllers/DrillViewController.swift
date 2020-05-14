//
//  DrillViewController.swift
//  PoolDrills
//
//  Created by Marius on 2020-03-27.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class DrillViewController: UITableViewController {

    lazy var drill: Drill = {
        return Drill(context: coredata.managedContext)
    }()

    private let coredata = CoreDataStack()

    @IBOutlet private weak var titleField: UITextField!
    @IBOutlet private weak var attemptsSlider: UISlider!
    @IBOutlet private weak var durationSlider: UISlider!

    @IBAction private func cancelButtonTapped(_ sender: UIBarButtonItem) {

        navigationController?.popViewController(animated: true)
    }

    @IBAction private func saveButtonTapped(_ sender: UIBarButtonItem) {
        drill.title = titleField.text
        drill.attempts = Int32(attemptsSlider.value)
        drill.duration = Double(durationSlider.value).rounded(.up)

        coredata.saveContext()

        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        titleField.text = drill.title
        attemptsSlider.value = Float(drill.attempts)
        durationSlider.value = Float(drill.duration)
    }
}
