//
//  ResultsViewController.swift
//  PoolDrills
//
//  Created by Marius on 2020-05-14.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class ResultsViewController: UITableViewController {

    var datasource = [DrillRecord]()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell", for: indexPath)

        let record = datasource[indexPath.row]
        cell.textLabel?.text = "\(String(describing: record.title)) \(record.recordedDuration) \(record.hitCount) \(record.missCount)"

        return cell
    }

}
