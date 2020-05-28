//
//  RoutineSetupViewController.swift
//  PoolDrills
//
//  Created by Marius on 2020-03-29.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class RoutineSetupViewController: UITableViewController {

    lazy var routine: Routine = {
        return Routine(context: coredata.managedContext)
    }()

    private let coredata = CoreDataStack()

    @IBOutlet private weak var titleField: UITextField!
    @IBOutlet private weak var selectedDrillsCount: UILabel!
    @IBOutlet private weak var saveButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleField.delegate = self

        titleField.insertText(routine.title ?? "")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let drills = routine.drills else { return }
        selectedDrillsCount.text = String(drills.count)
    }

    @IBAction private func titleFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }

        saveButton.isEnabled = text.isEmpty ? false : true
    }

    @IBAction private func cancelButtonDidTap(_ sender: UIBarButtonItem) {
        coredata.managedContext.rollback()

        navigationController?.popViewController(animated: true)
    }

    @IBAction private func saveButtonDidTap(_ sender: UIBarButtonItem) {
        routine.title = titleField.text
        coredata.saveContext()

        navigationController?.popViewController(animated: true)
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectDrills" {
            guard let vc = segue.destination as? DrillsSelectionViewController else { return }
            vc.routine = routine
        }
    }
}

extension RoutineSetupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text else { return false }
        guard let rangeOfTextToReplace = Range(range, in: textFieldText) else { return false }

        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count

        return count <= 19
    }
}
