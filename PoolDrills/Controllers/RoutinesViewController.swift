//
//  RoutinesViewController.swift
//  PoolDrills
//
//  Created by Marius on 2020-03-28.
//  Copyright © 2020 Marius. All rights reserved.
//

import CoreData
import UIKit

final class RoutinesViewController: UITableViewController {

    private let coreDataStack = CoreDataStack()

    private lazy var fetchedResultsController: NSFetchedResultsController<Routine> = {
        let fetchRequest: NSFetchRequest<Routine> = Routine.fetchRequest()

        let titleSort = NSSortDescriptor(key: #keyPath(Routine.title), ascending: true)
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
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineCell", for: indexPath) as! RoutinesViewCell
        cell.delegate = self

        let routine = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = routine.title

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
        if segue.identifier == "RoutineViewController" {
            guard let vc = segue.destination as? RoutineViewController else { return }
            guard let cell = sender as? UITableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            vc.routine = fetchedResultsController.object(at: indexPath)

            vc.hidesBottomBarWhenPushed = true
        }

        if segue.identifier == "RunnerViewController" {
            guard let vc = segue.destination as? RunnerViewController else { return }
            guard let cell = sender as? UITableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            vc.routine = fetchedResultsController.object(at: indexPath)

            vc.hidesBottomBarWhenPushed = true
        }
    }
}

extension RoutinesViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                    at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
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

extension RoutinesViewController: RoutineRunButtonDelegate {
    func routineRunButtonDidTap(inside cell: UITableViewCell) {
        performSegue(withIdentifier: "RunnerViewController", sender: cell)
    }
}
