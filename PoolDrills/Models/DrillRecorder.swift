//
//  DrillRecorder.swift
//  PoolDrills
//
//  Created by Marius on 2020-05-14.
//  Copyright © 2020 Marius. All rights reserved.
//

import Foundation

protocol DrillRecording {
    func getRecords() -> [DrillRecord]
    func createRecord(with drill: Drill)
    func recordDuration(_ duration: TimeInterval)
    func recordHitCount(_ count: Int)
    func recordMissCount(_ count: Int)
}

final class DrillRecorder: DrillRecording {

    private var currentRecord: DrillRecord?
    private var records = [DrillRecord]()

    func getRecords() -> [DrillRecord] {
        return records
    }

    func createRecord(with drill: Drill) {
        let record = DrillRecord(drill: drill)
        currentRecord = record
        records.append(record)
    }

    func recordDuration(_ duration: TimeInterval) {
        currentRecord?.recordedDuration = duration
    }

    func recordHitCount(_ count: Int) {
        currentRecord?.hitCount = count
    }

    func recordMissCount(_ count: Int) {
        currentRecord?.missCount = count
    }

}
