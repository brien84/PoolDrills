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

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "routineCell", for: indexPath) as! RoutineCell

        let routine = fetchedResultsController.object(at: indexPath)

        cell.title.text = routine.title
        cell.runButton.isEnabled = routine.containsDrills

        cell.delegate = self

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createRoutine" || segue.identifier == "editRoutine" {
            guard let vc = segue.destination as? RoutineSetupViewController else { return }
            vc.hidesBottomBarWhenPushed = true

            guard let cell = sender as? UITableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            vc.routine = fetchedResultsController.object(at: indexPath)
        }

        if segue.identifier == "runRoutine" {
            guard let vc = segue.destination as? RoutineRunningViewController else { return }
            vc.hidesBottomBarWhenPushed = true

            guard let cell = sender as? UITableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            vc.routine = fetchedResultsController.object(at: indexPath)
        }
    }

}

extension FetchedRoutinesViewController: RoutineCellRunButtonDelegate {
    func routineRunButtonDidTap(_ button: UIButton, inside cell: UITableViewCell) {
        performSegue(withIdentifier: "runRoutine", sender: cell)
    }
}
