//
//  DrillsViewController.swift
//  PoolDrills
//
//  Created by Marius on 2020-03-07.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class DrillsViewController: FetchedTableViewController<Drill> {

    override var sortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title", ascending: true)]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrillsCell", for: indexPath)

        let drill = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = drill.title

        return cell
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
