//
//  DrillRecord.swift
//  PoolDrills
//
//  Created by Marius on 2020-05-14.
//  Copyright © 2020 Marius. All rights reserved.
//

import Foundation

final class DrillRecord {
    private let drill: Drill

    var title: String? {
        return drill.title
    }

    var attempts: Int {
        return drill.attempts
    }

    var seconds: TimeInterval {
        return drill.seconds
    }

    var recordedTime: TimeInterval = 0
    var hitCount = 0
    var missCount = 0

    init(drill: Drill) {
        self.drill = drill
    }
}
