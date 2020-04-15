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

    private var coreDataStack = CoreDataStack()

    private lazy var fetchedResultsController: NSFetchedResultsController<Drill> = {
        let fetchRequest: NSFetchRequest<Drill> = Drill.fetchRequest()

        let titleSort = NSSortDescriptor(key: #keyPath(Drill.title), ascending: true)
        fetchRequest.sortDescriptors = [titleSort]

        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)

        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }

        return section.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrillsSelectionCell", for: indexPath)

        let drill = fetchedResultsController.object(at: indexPath)

        cell.textLabel?.text = drill.title

        guard let drills = routine?.drills else { return cell }
        cell.accessoryType = drills.contains(drill) ? .checkmark : .none

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let drill = fetchedResultsController.object(at: indexPath)
        guard let drills = routine?.drills else { return }

        if drills.contains(drill) {
            routine?.removeFromDrills(drill)
        } else {
            routine?.addToDrills(drill)
        }

        tableView.reloadData()
    }
}
