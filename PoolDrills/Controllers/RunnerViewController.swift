//
//  RunnerViewController.swift
//  PoolDrills
//
//  Created by Marius on 2020-04-15.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class RunnerViewController: UIViewController {

    var routine: Routine?

    private var runner: DrillRunnable = DrillRunner()

    @IBOutlet private weak var drillTitle: UILabel!
    @IBOutlet private weak var totalTime: UILabel!
    @IBOutlet private weak var drillTime: UILabel!
    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet private weak var missButton: UIButton!
    @IBOutlet private weak var hitButton: UIButton!
    @IBOutlet private weak var attemptsCount: UILabel!

    convenience init(routine: Routine, runner: DrillRunnable) {
        self.init()

        self.routine = routine
        self.runner = runner
    }

    @IBAction private func actionButtonDidTap(_ sender: UIButton) {

    }

    @IBAction private func missButtonDidTap(_ sender: UIButton) {

    }

    @IBAction private func hitButtonDidTap(_ sender: UIButton) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = routine?.title

        if let drills = routine?.drills?.allObjects as? [Drill] {
            runner.add(drills)
        } else {
            // TODO: Display Error
        }
    }
}
