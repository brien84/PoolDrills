//
//  RoutineViewController.swift
//  PoolDrills
//
//  Created by Marius on 2020-03-29.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class RoutineViewController: UITableViewController {

    lazy var routine: Routine = {
        return Routine(context: coredata.managedContext)
    }()

    private let coredata = CoreDataStack()

    @IBOutlet private weak var titleField: UITextField!
    @IBOutlet private weak var selectedDrillsCount: UILabel!

    @IBAction private func cancelButtonTapped(_ sender: UIBarButtonItem) {
        coredata.managedContext.rollback()

        navigationController?.popViewController(animated: true)
    }

    @IBAction private func saveButtonTapped(_ sender: UIBarButtonItem) {
        routine.title = titleField.text
        coredata.saveContext()

        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        titleField.text = routine.title
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let drills = routine.drills else { return }
        selectedDrillsCount.text = String(drills.count)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DrillsSelection" {

            guard let vc = segue.destination as? DrillsSelectionViewController else { return }
            vc.routine = routine
        }
    }
}
