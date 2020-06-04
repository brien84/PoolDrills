//
//  FetchedDrillsViewController.swift
//  PoolDrills
//
//  Created by Marius on 2020-03-07.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class FetchedDrillsViewController: FetchedTableViewController<Drill> {

    override var sortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title", ascending: true)]
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "drillCell", for: indexPath) as! DrillCell

        let drill = fetchedResultsController.object(at: indexPath)

        cell.title.text = drill.title
        cell.attempts.text = String(drill.attempts)
        cell.duration.text = String(drill.minutes)

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createDrill" || segue.identifier == "editDrill" {
            guard let vc = segue.destination as? DrillSetupViewController else { return }
            vc.hidesBottomBarWhenPushed = true
            guard let cell = sender as? UITableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            vc.drill = fetchedResultsController.object(at: indexPath)
        }
    }

}
