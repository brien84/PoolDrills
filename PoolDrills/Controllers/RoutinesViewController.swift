//
//  RoutinesViewController.swift
//  PoolDrills
//
//  Created by Marius on 2020-03-28.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class RoutinesViewController: FetchedTableViewController<Routine> {

    override var sortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title", ascending: true)]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineCell", for: indexPath) as! RoutinesViewCell
        cell.delegate = self

        let routine = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = routine.title

        return cell
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

extension RoutinesViewController: RoutineRunButtonDelegate {
    func routineRunButtonDidTap(inside cell: UITableViewCell) {
        performSegue(withIdentifier: "RunnerViewController", sender: cell)
    }
}
