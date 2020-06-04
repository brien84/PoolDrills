//
//  DrillsSelectionViewController.swift
//  PoolDrills
//
//  Created by Marius on 2020-03-29.
//  Copyright © 2020 Marius. All rights reserved.
//

import CoreData
import UIKit

final class DrillsSelectionViewController: UITableViewController {

    var routine: Routine?

    private var datasource = [Drill]()
    private var selectedDrills = [Drill]()

    override func viewDidLoad() {
        super.viewDidLoad()

        isEditing = true

        setupDatasource()

        if datasource.count < 0 {
            // TODO: Display Error
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let drills = datasource.filter { selectedDrills.contains($0) }
        routine?.drills = NSOrderedSet(array: drills)
    }

    @IBAction private func doneButtonDidTap(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    private func setupDatasource() {
        if let routineDrills = routine?.drills?.array as? [Drill] {
            datasource.append(contentsOf: routineDrills)
            selectedDrills.append(contentsOf: routineDrills)
        }

        let coreDataStack = CoreDataStack()
        let fetchRequest: NSFetchRequest<Drill> = Drill.fetchRequest()

        if let drills = try? coreDataStack.managedContext.fetch(fetchRequest) {
            let filteredDrills = drills.filter { !datasource.contains($0) }
            datasource.append(contentsOf: filteredDrills)
        }
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datasource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "drillsSelectionCell", for: indexPath) as! DrillCell

        let drill = datasource[indexPath.row]

        cell.title.text = drill.title
        cell.attempts.text = String(drill.attempts)
        cell.duration.text = String(drill.minutes)

        return cell
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let drill = datasource[sourceIndexPath.row]
        datasource.remove(at: sourceIndexPath.row)
        datasource.insert(drill, at: destinationIndexPath.row)
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let drill = datasource[indexPath.row]

        if selectedDrills.contains(drill) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let drill = datasource[indexPath.row]
        selectedDrills.append(drill)
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let drill = datasource[indexPath.row]
        selectedDrills.removeAll { $0 == drill }
    }
}
