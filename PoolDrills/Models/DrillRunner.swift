//
//  RoutineRunner.swift
//  PoolDrills
//
//  Created by Marius on 2020-04-18.
//  Copyright © 2020 Marius. All rights reserved.
//

import Foundation

protocol DrillRunnable {
    var selectedDrill: Drill? { get }

    func add(_ drills: [Drill])
    func nextDrill()
}

final class DrillRunner: DrillRunnable {

    private var drills: [Drill]

    private var selectedIndex = 0

    var selectedDrill: Drill? {
        guard !drills.isEmpty else { return nil }
        return drills[selectedIndex]
    }

    init(with drills: [Drill] = []) {
        self.drills = drills
    }

    func add(_ drills: [Drill]) {
        self.drills.append(contentsOf: drills)
    }

    func nextDrill() {
        if drills.indices.last != selectedIndex {
            selectedIndex += 1
        }
    }
}
