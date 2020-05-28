//
//  DrillTracker.swift
//  PoolDrills
//
//  Created by Marius on 2020-04-18.
//  Copyright © 2020 Marius. All rights reserved.
//

import Foundation

protocol DrillTracking {
    var delegate: DrillTrackingDelegate? { get }

    func load(_ drills: [Drill])
    func endDrill()
    func registerAttempt(as successful: Bool)
    func toggle()
}

protocol DrillTrackingDelegate: AnyObject {
    func drillTracking(_ tracker: DrillTracking, didLoad drill: Drill)
    func drillTrackingDidStart(_ tracker: DrillTracking)
    func drillTrackingDidPause(_ tracker: DrillTracking)
    func drillTrackingDidCompleteDrill(_ tracker: DrillTracking)
    func drillTrackingDidFinish(_ tracker: DrillTracking, with records: [DrillRecord])
}

final class DrillTracker: DrillTracking {

    weak var delegate: DrillTrackingDelegate?

    private var drills = [Drill]()
    private var selectedIndex = 0

    private var selectedDrill: Drill {
        assert(!drills.isEmpty)
        return drills[selectedIndex]
    }

    private lazy var attemptsTracker: AttemptsTracking = AttemptsTracker()
    private lazy var durationTracker: DurationTracking = DurationTracker()
    private lazy var drillRecorder: DrillRecording = DrillRecorder()

    private var state: State? {
        didSet {
            switch state {
            case .ready:
                delegate?.drillTracking(self, didLoad: selectedDrill)
            case .running:
                durationTracker.start()
                delegate?.drillTrackingDidStart(self)
            case .paused:
                durationTracker.pause()
                delegate?.drillTrackingDidPause(self)
            case .idle:
                durationTracker.pause()
                delegate?.drillTrackingDidCompleteDrill(self)
            case .finished:
                durationTracker.pause()
                delegate?.drillTrackingDidFinish(self, with: drillRecorder.getRecords())
            default:
                break
            }
        }
    }

    init() {
        setupNotifications()
    }

    convenience init(_ attemptsTracker: AttemptsTracking, _ durationTracker: DurationTracking, _ drillRecorder: DrillRecording) {
        self.init()

        self.attemptsTracker = attemptsTracker
        self.durationTracker = durationTracker
        self.drillRecorder = drillRecorder
    }

    func toggle() {
        switch state {
        case .ready:
            state = .running
        case .idle:
            next()
        case .running:
            state = .paused
        case .paused:
            state = .running
        case .finished:
            break
        default:
            break
        }
    }

    func load(_ drills: [Drill]) {
        guard !drills.isEmpty else { return }
        self.drills = drills
        load(selectedDrill)
    }

    private func load(_ drill: Drill) {
        durationTracker.load(drill)
        attemptsTracker.load(drill)
        drillRecorder.createRecord(with: drill)

        state = .ready
    }

    private func next() {
        if drills.indices.last != selectedIndex {
            selectedIndex += 1
            load(selectedDrill)
        } else {
            state = .finished
        }
    }

    func endDrill() {
        state = .idle
    }

    func registerAttempt(as successful: Bool) {
        attemptsTracker.registerAttempt(as: successful)
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

        guard let drillDuration = info[.drillDuration] else { return }

        drillRecorder.recordDuration(drillDuration)

        if drillDuration == 0 {
            state = .idle
        }
    }

    @objc private func handleAttemptsNotification(_ notification: NSNotification) {
        guard let info = notification.userInfo as? [AttemptsTrackingKeys: Int] else { return }

        guard let attemptsLimit = info[.attemptsLimit] else { return }
        guard let hitCount = info[.hitCount] else { return }
        guard let missCount = info[.missCount] else { return }

        drillRecorder.recordHitCount(hitCount)
        drillRecorder.recordMissCount(missCount)

        if hitCount + missCount == attemptsLimit {
            state = .idle
        }
    }
}

extension DrillTracker {
    private enum State {
        case ready
        case running
        case paused
        case idle
        case finished
    }
}
