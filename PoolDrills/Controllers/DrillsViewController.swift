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

    private let coreDataStack = CoreDataStack()

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

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let drill = fetchedResultsController.object(at: indexPath)
            coreDataStack.managedContext.delete(drill)
            coreDataStack.saveContext()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DrillViewController" {

            guard let vc = segue.destination as? DrillViewController else { return }
            guard let cell = sender as? UITableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            vc.drill = fetchedResultsController.object(at: indexPath)

            vc.hidesBottomBarWhenPushed = true
        }
    }
}

extension DrillsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .fade)
        case .move:
            guard let indexPath = indexPath else { return }
            guard let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.insertRows(at: [newIndexPath], with: .fade)
        @unknown default:
            return
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
