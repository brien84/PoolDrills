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

    private lazy var runner: DrillRunnable = {
        let runner = DrillRunner()
        runner.delegate = self
        return runner
    }()

    @IBOutlet private weak var drillTitle: UILabel!
    @IBOutlet private weak var totalTime: UILabel!
    @IBOutlet private weak var drillTime: UILabel!
    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet private weak var missButton: UIButton!
    @IBOutlet private weak var missCount: UILabel!
    @IBOutlet private weak var hitButton: UIButton!
    @IBOutlet private weak var hitCount: UILabel!
    @IBOutlet private weak var attemptsCount: UILabel!
    @IBOutlet private weak var completionButton: UIButton!

    convenience init(routine: Routine, runner: DrillRunnable) {
        self.init()

        self.routine = routine
        self.runner = runner
    }

    @IBAction private func actionButtonDidTap(_ sender: UIButton) {
        runner.start()
    }

    @IBAction private func missButtonDidTap(_ sender: UIButton) {

    }

    @IBAction private func hitButtonDidTap(_ sender: UIButton) {

    }

    @IBAction private func completionButtonDidTap(_ sender: UIButton) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = routine?.title

        if let drills = routine?.drills?.array as? [Drill]  {
            runner.add(drills)

            totalTime.text = "00:00"
            drillTime.text = runner.selectedDrill?.duration.toString()
        } else {
            // TODO: Display Error
        }

    }
}

extension RunnerViewController: DrillRunnableDelegate {
    func drillRunnable(_ object: DrillRunnable, didUpdate totalTime: TimeInterval, and drillTime: TimeInterval) {

        self.totalTime.text = totalTime.toString()
        self.drillTime.text = drillTime.toString()
    }

    func drillRunnableDidFinishRunning(_ object: DrillRunnable, isLastDrill: Bool) {

    }
}

extension TimeInterval {
    func toString() -> String {
        let hours = Int(self) / 3600
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60

        if hours != 0 {
            return String(format: "%02d:%02d:%02d", arguments: [hours, minutes, seconds])
        } else {
            return String(format: "%02d:%02d", arguments: [minutes, seconds])
        }
    }
}
