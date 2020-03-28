//
//  DrillsViewController.swift
//  PoolDrills
//
//  Created by Marius on 2020-03-07.
//  Copyright © 2020 Marius. All rights reserved.
//

import CoreData
import UIKit

class DrillsViewController: UITableViewController {

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private var datasource = [Drill]()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadData()
    }

    private func loadData() {
        let request: NSFetchRequest<Drill> = Drill.fetchRequest()

        do {
            datasource = try context.fetch(request)
        } catch {
            print(error)
        }

        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrillsCell", for: indexPath)

        cell.textLabel?.text = datasource[indexPath.row].name

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "DrillViewController" {

            guard let vc = segue.destination as? DrillViewController else { return }
            guard let cell = sender as? UITableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            vc.drill = datasource[indexPath.row]
        }
    }

}
