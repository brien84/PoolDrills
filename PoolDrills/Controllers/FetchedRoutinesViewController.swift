//
//  FetchedRoutinesViewController.swift
//  PoolDrills
//
//  Created by Marius on 2020-03-28.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class FetchedRoutinesViewController: FetchedTableViewController<Routine> {

    override var sortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title", ascending: true)]
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "routineCell", for: indexPath) as! RoutinesViewCell

        let routine = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = routine.title

        cell.delegate = self

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createRoutine" || segue.identifier == "editRoutine" {
            guard let vc = segue.destination as? CreateRoutineViewController else { return }
            guard let cell = sender as? UITableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            vc.routine = fetchedResultsController.object(at: indexPath)
        }

        if segue.identifier == "runRoutine" {
            guard let vc = segue.destination as? RunnerViewController else { return }
            guard let cell = sender as? UITableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            vc.routine = fetchedResultsController.object(at: indexPath)
        }
    }

}

extension FetchedRoutinesViewController: RoutineRunButtonDelegate {
    func routineRunButtonDidTap(inside cell: UITableViewCell) {
        performSegue(withIdentifier: "runRoutine", sender: cell)
    }
}
