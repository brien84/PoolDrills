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

    private var routineTime: TimeInterval = 0
    private var drillTime: TimeInterval = 0
    private var isCountdown = false

    deinit {
        timer?.invalidate()
    }

    func load(_ drill: Drill) {
        drillTime = drill.seconds
        isCountdown = drill.seconds > 0 ? true : false
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
            self.routineTime += 1
            self.drillTime += self.isCountdown ? -1 : 1

            self.postNotification()
        }

        timer.tolerance = 0.1
        RunLoop.current.add(timer, forMode: .common)

        return timer
    }

    private func postNotification() {
        let userInfo: [DurationTrackingKeys: TimeInterval] =
            [.routineTime: routineTime, .drillTime: drillTime]

        NotificationCenter.default.post(name: .durationTrackingDidUpdate, object: nil, userInfo: userInfo)
    }
}

enum DurationTrackingKeys: String {
    case routineTime
    case drillTime
}

extension Notification.Name {
    static let durationTrackingDidUpdate = Notification.Name("durationTrackingDidUpdateNotification")
}
