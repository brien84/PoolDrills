//
//  DurationTracker.swift
//  PoolDrills
//
//  Created by Marius on 2020-05-08.
//  Copyright © 2020 Marius. All rights reserved.
//

import Foundation

protocol DurationTracking {
    func load(_ drill: Drill)
    func start()
    func pause()
}

final class DurationTracker: DurationTracking {

    private var timer: Timer?

    private var totalDuration: TimeInterval = 0
    private var drillDuration: TimeInterval = 0
    private var isCountdown = false

    deinit {
        timer?.invalidate()
    }

    func load(_ drill: Drill) {
        if drill.duration > 0 {
            drillDuration = drill.duration
            isCountdown = true
        } else {
            drillDuration = 0
            isCountdown = false
        }
    }

    func start() {
        guard timer == nil else { return }

        timer = createTimer()
    }

    func pause() {
        timer?.invalidate()
        timer = nil
    }

    private func createTimer() -> Timer {
        let timer = Timer(timeInterval: 1.0, repeats: true) { [unowned self] _ in
            self.totalDuration += 1
            self.drillDuration += self.isCountdown ? -1 : 1

            self.postNotification()
        }

        timer.tolerance = 0.1
        RunLoop.current.add(timer, forMode: .common)

        return timer
    }

    private func postNotification() {
        let userInfo: [DurationTrackingKeys: TimeInterval] =
            [.totalDuration: totalDuration, .drillDuration: drillDuration]

        NotificationCenter.default.post(name: .durationTrackingDidUpdate, object: nil, userInfo: userInfo)
    }
}

enum DurationTrackingKeys: String {
    case totalDuration
    case drillDuration
}

extension Notification.Name {
    static let durationTrackingDidUpdate = Notification.Name("durationTrackingDidUpdateNotification")
}
