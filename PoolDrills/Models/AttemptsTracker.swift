//
//  AttemptsTracker.swift
//  PoolDrills
//
//  Created by Marius on 2020-05-08.
//  Copyright © 2020 Marius. All rights reserved.
//

import Foundation

protocol AttemptsTracking {
    func load(_ drill: Drill)
    func registerAttempt(as successful: Bool)
}

final class AttemptsTracker: AttemptsTracking {

    private var attempts = 0
    private var hitCount = 0
    private var missCount = 0

    func load(_ drill: Drill) {
        attempts = drill.attempts
        hitCount = 0
        missCount = 0
    }

    func registerAttempt(as successful: Bool) {
        if successful {
            hitCount += 1
        } else {
            missCount += 1
        }

        postNotification()
    }

    private func postNotification() {
        let userInfo: [AttemptsTrackingKeys: Int] =
            [.attempts: attempts, .hitCount: hitCount, .missCount: missCount]

        NotificationCenter.default.post(name: .attemptsTrackingDidUpdate, object: nil, userInfo: userInfo)
    }
}

enum AttemptsTrackingKeys: String {
    case attempts
    case hitCount
    case missCount
}

extension Notification.Name {
    static let attemptsTrackingDidUpdate = Notification.Name("attemptsTrackingDidUpdateNotification")
}
