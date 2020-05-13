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

    private var attemptsLimit = 0
    private var hitCount = 0
    private var missCount = 0

    func load(_ drill: Drill) {
        hitCount = 0
        missCount = 0

        attemptsLimit = drill.attempts > 0 ? Int(drill.attempts) : 0
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
        let userInfo: [AttemptsTrackingKeys : Int] =
            [.attemptsLimit : attemptsLimit, .hitCount : hitCount, .missCount : missCount]

        NotificationCenter.default.post(name: .AttemptsTrackingDidUpdate, object: nil, userInfo: userInfo)
    }
    
}

enum AttemptsTrackingKeys: String {
    case attemptsLimit
    case hitCount
    case missCount
}

extension Notification.Name {
    static let AttemptsTrackingDidUpdate = Notification.Name("AttemptsTrackingDidUpdateNotification")
}
