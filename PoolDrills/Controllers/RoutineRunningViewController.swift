//
//  RoutineRunningViewController.swift
//  PoolDrills
//
//  Created by Marius on 2020-04-15.
//  Copyright © 2020 Marius. All rights reserved.
//

import AVFoundation
import UIKit

final class RoutineRunningViewController: UIViewController {

    var routine: Routine?

    private lazy var drillTracker: DrillTracking = {
        let tracker = DrillTracker()
        tracker.delegate = self
        return tracker
    }()

    private var queueController: DrillsQueueViewController? {
        let controller = children.first { $0.isKind(of: DrillsQueueViewController.self) }

        return controller as? DrillsQueueViewController
    }

    private var records = [DrillRecord]()
    private var shouldStartCountdown = false

    @IBOutlet private weak var routineTitle: UILabel!

    @IBOutlet private weak var routineTime: UILabel!
    @IBOutlet private weak var missCount: UILabel!
    @IBOutlet private weak var hitCount: UILabel!

    @IBOutlet private weak var actionButton: ActionButton!
    @IBOutlet private weak var attemptsProgress: UIProgressView!

    @IBOutlet private var toggleableButtons: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()

        routineTitle.text = routine?.title

        if let drills = routine?.drills?.array as? [Drill] {
            assert(!drills.isEmpty)
            setupNotifications()
            queueController?.datasource = drills
            drillTracker.load(drills)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        navigationController?.viewControllers.removeAll { $0.isKind(of: RoutineRunningViewController.self) }
    }

    @IBAction private func actionButtonDidTap(_ sender: ActionButton) {
        if shouldStartCountdown {
            shouldStartCountdown = false

            actionButton.countdown { [weak self] in
                self?.drillTracker.toggle()
            }

        } else {
            drillTracker.toggle()
        }
    }

    @IBAction private func completionButtonDidTap(_ sender: UIButton) {
        let alert = ConfirmationPopoverViewController(in: self, on: sender)

        alert.present {
            if $0 { self.drillTracker.endDrill() }
        }
    }

    @IBAction private func exitButtonDidTap(_ sender: UIButton) {
        let alert = ConfirmationPopoverViewController(in: self, on: sender)

        alert.present {
            if $0 { self.navigationController?.popViewController(animated: true) }
        }
    }

    @IBAction private func missButtonDidTap(_ sender: UIButton) {
        drillTracker.registerAttempt(as: false)
    }

    @IBAction private func hitButtonDidTap(_ sender: UIButton) {
        drillTracker.registerAttempt(as: true)
    }

    private func toggleButtons(enabled isEnabled: Bool) {
        toggleableButtons.forEach { $0.isEnabled = isEnabled }
    }

    // MARK: - Notifications

    private func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleDurationNotification(_:)),
                                               name: .durationTrackingDidUpdate,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleAttemptsNotification(_:)),
                                               name: .attemptsTrackingDidUpdate,
                                               object: nil)
    }

    @objc private func handleDurationNotification(_ notification: NSNotification) {
        guard let info = notification.userInfo as? [DurationTrackingKeys: TimeInterval] else { return }

        routineTime.text = info[.routineTime]?.digitalFormat
    }

    @objc private func handleAttemptsNotification(_ notification: NSNotification) {
        guard let info = notification.userInfo as? [AttemptsTrackingKeys: Int] else { return }

        guard let attempts = info[.attempts] else { return }
        guard let hitCount = info[.hitCount] else { return }
        guard let missCount = info[.missCount] else { return }

        self.hitCount.text = String(hitCount)
        self.missCount.text = String(missCount)

        if attempts > 0 {
            attemptsProgress.progress = Float(hitCount + missCount) / Float(attempts)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResults" {
            guard let vc = segue.destination as? ResultsViewController else { return }
            vc.datasource = records
            vc.routineTitle = routineTitle.text
            vc.routineDuration = routineTime.text
        }
    }
}

extension RoutineRunningViewController: DrillTrackingDelegate {
    func drillTracking(_ tracker: DrillTracking, didLoad drill: Drill) {
        missCount.text = String(0)
        hitCount.text = String(0)
        attemptsProgress.progress = 0
        attemptsProgress.isHidden = drill.attempts > 0 ? false : true

        toggleButtons(enabled: false)
        actionButton.set(image: .play)

        shouldStartCountdown = true

        queueController?.next()
    }

    func drillTrackingDidStart(_ tracker: DrillTracking) {
        toggleButtons(enabled: true)
        actionButton.set(image: .pause)

        UIDevice.vibrate()
    }

    func drillTrackingDidPause(_ tracker: DrillTracking) {
        toggleButtons(enabled: false)
        actionButton.set(image: .play)

        shouldStartCountdown = true
    }

    func drillTrackingDidCompleteDrill(_ tracker: DrillTracking) {
        toggleButtons(enabled: false)
        actionButton.set(image: .next)

        UIDevice.vibrate()
    }

    func drillTrackingDidFinish(_ tracker: DrillTracking, with records: [DrillRecord]) {
        toggleButtons(enabled: false)
        actionButton.set(image: .next)

        self.records = records
        performSegue(withIdentifier: "showResults", sender: nil)
    }
}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
