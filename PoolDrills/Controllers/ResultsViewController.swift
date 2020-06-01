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
    var routineTitle: String?
    var routineDuration: String?

    @IBOutlet private weak var routineTitleLabel: UILabel!
    @IBOutlet private weak var routineDurationLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        routineTitleLabel.text = routineTitle
        routineDurationLabel.text = routineDuration

        resizeHeader()
    }

    @IBAction private func doneButtonDidTap(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))

        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultsCell", for: indexPath) as! ResultsViewCell

        let record = datasource[indexPath.row]

        cell.title.text = record.title
        cell.duration.text = "10:00"
        cell.hitCount.text = "100"
        cell.hitCount.text = "100"

        return cell
    }
}

extension ResultsViewController {
    private func resizeHeader() {
        if let headerView = tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var frame = headerView.frame
            frame.size.height = height
            headerView.frame = frame

            tableView.tableHeaderView = headerView
        }
    }
}
