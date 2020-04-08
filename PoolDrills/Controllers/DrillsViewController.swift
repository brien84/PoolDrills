//
//  DrillsViewController.swift
//  PoolDrills
//
//  Created by Marius on 2020-03-07.
//  Copyright © 2020 Marius. All rights reserved.
//

import CoreData
import UIKit

final class DrillsViewController: UITableViewController {

    private var coreDataStack: CoreDataStack

    private lazy var fetchedResultsController: NSFetchedResultsController<Drill> = {
        let fetchRequest: NSFetchRequest<Drill> = Drill.fetchRequest()

        let titleSort = NSSortDescriptor(key: #keyPath(Drill.title), ascending: true)
        fetchRequest.sortDescriptors = [titleSort]

        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)

        controller.delegate = self

        return controller
    }()


    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack

        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        self.coreDataStack = CoreDataStack()

        super.init(coder: coder)
    }

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrillsCell", for: indexPath)

        let drill = fetchedResultsController.object(at: indexPath)

        cell.textLabel?.text = drill.title

        return cell
    }
}

extension DrillsViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
