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

    private lazy var drillTracker: DrillTracking = {
        let tracker = DrillTracker()
        tracker.delegate = self
        return tracker
    }()

    @IBOutlet private weak var drillTitle: UILabel!
    @IBOutlet private weak var totalTime: UILabel!
    @IBOutlet private weak var drillTime: UILabel!
    @IBOutlet private weak var missCount: UILabel!
    @IBOutlet private weak var hitCount: UILabel!

    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet private weak var missButton: UIButton!
    @IBOutlet private weak var hitButton: UIButton!
    @IBOutlet private weak var completionButton: UIButton!

    @IBOutlet private weak var attemptsProgress: UIProgressView!

    @IBAction private func actionButtonDidTap(_ sender: UIButton) {
        drillTracker.toggle()
    }

    @IBAction private func missButtonDidTap(_ sender: UIButton) {
        drillTracker.registerAttempt(as: false)
    }

    @IBAction private func hitButtonDidTap(_ sender: UIButton) {
        drillTracker.registerAttempt(as: true)
    }

    @IBAction private func completionButtonDidTap(_ sender: UIButton) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = routine?.title
        
        if let drills = routine?.drills?.array as? [Drill], !drills.isEmpty  {
            drillTracker.load(drills)
            setupNotifications()
        } else {
            // TODO: Display Error
        }
    }

    private func toggleButtons(enabled isEnabled: Bool) {
        missButton.isEnabled = isEnabled
        hitButton.isEnabled = isEnabled
        completionButton.isEnabled = isEnabled
    }

    // MARK: - Notifications

    private func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleDurationNotification(_:)),
                                               name: .DurationTrackingDidUpdate,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleAttemptsNotification(_:)),
                                               name: .AttemptsTrackingDidUpdate,
                                               object: nil)
    }

    @objc private func handleDurationNotification(_ notification: NSNotification) {
        guard let info = notification.userInfo as? [DurationTrackingKeys : TimeInterval] else { return }

        totalTime.text = info[.totalDuration]?.toString()
        drillTime.text = info[.drillDuration]?.toString()
    }

    @objc private func handleAttemptsNotification(_ notification: NSNotification) {
        guard let info = notification.userInfo as? [AttemptsTrackingKeys : Int] else { return }

        guard let attemptsLimit = info[.attemptsLimit] else { return }
        guard let hitCount = info[.hitCount] else { return }
        guard let missCount = info[.missCount] else { return }

        self.hitCount.text = String(hitCount)
        self.missCount.text = String(missCount)

        if attemptsLimit > 0 {
            attemptsProgress.progress = Float(hitCount + missCount) / Float(attemptsLimit)
        }
    }
}

extension RunnerViewController: DrillTrackingDelegate {
    func drillTracking(_ tracker: DrillTracking, didLoad drill: Drill) {
        drillTitle.text = drill.title

        drillTime.text = drill.duration.toString()

        missCount.text = String(0)
        hitCount.text = String(0)
        attemptsProgress.progress = 0
        attemptsProgress.isHidden = drill.attempts > 0 ? false : true

        toggleButtons(enabled: false)
        actionButton.setTitle("Start", for: .normal)
    }

    func drillTrackingDidStart(_ tracker: DrillTracking) {
        toggleButtons(enabled: true)
        actionButton.setTitle("Pause", for: .normal)
    }

    func drillTrackingDidPause(_ tracker: DrillTracking) {
        toggleButtons(enabled: false)
        actionButton.setTitle("Resume", for: .normal)
    }

    func drillTrackingDidCompleteDrill(_ tracker: DrillTracking) {
        toggleButtons(enabled: false)
        actionButton.setTitle("Next", for: .normal)
    }

    func drillTrackingDidFinishDrills(_ tracker: DrillTracking) {
        toggleButtons(enabled: false)
        actionButton.setTitle("Finished", for: .normal)
    }
}

extension TimeInterval {
    func toString() -> String {
        let hours = Int(self) / 3600
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60

        if hours > 0 {
            return String(format: "%02d:%02d:%02d", arguments: [hours, minutes, seconds])
        } else {
            return String(format: "%02d:%02d", arguments: [minutes, seconds])
        }
    }
}
