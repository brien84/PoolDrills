//
//  RoutineRunner.swift
//  PoolDrills
//
//  Created by Marius on 2020-04-18.
//  Copyright © 2020 Marius. All rights reserved.
//

import Foundation

protocol DrillRunnable {
    var delegate: DrillRunnableDelegate? { get }
    var selectedDrill: Drill? { get }

    func add(_ drills: [Drill])
    func next()
    func start()
}

protocol DrillRunnableDelegate: AnyObject {
    func drillRunnable(_ object: DrillRunnable, didUpdate totalTime: TimeInterval, and drillTime: TimeInterval)
    func drillRunnableDidFinishRunning(_ object: DrillRunnable, isLastDrill: Bool)
}

final class DrillRunner: DrillRunnable {

    weak var delegate: DrillRunnableDelegate?

    private var drills = [Drill]()
    private var selectedIndex = 0

    var selectedDrill: Drill? {
        guard !drills.isEmpty else { return nil }
        return drills[selectedIndex]
    }

    private var timeTracker: Timeable
    private var drillTime = TimeInterval()
    private var isCountdown = false

    init(with drills: [Drill] = [], _ timeTracker: Timeable = TimeTracker()) {
        self.timeTracker = timeTracker
        self.timeTracker.delegate = self

        self.add(drills)
    }

    func add(_ drills: [Drill]) {
        self.drills.append(contentsOf: drills)
        prepare()
    }

    private func prepare() {
        guard let drill = selectedDrill else { return }

        if drill.duration > 0 {
            drillTime = drill.duration
            isCountdown = true
        } else {
            drillTime = 0
            isCountdown = false
        }
    }

    func next() {
        if drills.indices.last != selectedIndex {
            selectedIndex += 1
            prepare()
        }
    }

    func start() {
        timeTracker.start()
    }
}

extension DrillRunner: TimeableDelegate {
    func timeable(_ object: Timeable, didUpdate time: TimeInterval) {
        drillTime += isCountdown ? -1 : 1

        if drillTime == 0 {
            delegate?.drillRunnableDidFinishRunning(self, isLastDrill: false)
        }

        delegate?.drillRunnable(self, didUpdate: time, and: drillTime)
    }
}
