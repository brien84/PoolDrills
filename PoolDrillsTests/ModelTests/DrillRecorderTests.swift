//
//  DrillRecorderTests.swift
//  PoolDrillsTests
//
//  Created by Marius on 2020-05-14.
//  Copyright © 2020 Marius. All rights reserved.
//

@testable import PoolDrills
import XCTest

class DrillRecorderTests: XCTestCase {

    var sut: DrillRecorder?

    override func setUp() {
        sut = DrillRecorder()
    }

    override func tearDown() {
        sut = nil
        TestCoreDataHelper.resetContext()
    }

    func testCreatingRecord() {
        // given
        let drill = createDrill()

        // when
        sut?.createRecord(with: drill)

        // then
        guard let record = sut?.getRecords().first else { XCTFail("`getRecords()` returns nil."); return }
        XCTAssertEqual(record.title, drill.title)
        XCTAssertEqual(record.attempts, Int(drill.attempts))
        XCTAssertEqual(record.duration, drill.duration)
    }

    func testCreatingFiftyRecords() {
        // given
        let drill = createDrill()
        let recordCount = 50

        // when
        for _ in 1...50 {
            sut?.createRecord(with: drill)
        }

        // then
        guard let records = sut?.getRecords() else { XCTFail("`getRecords()` returns nil."); return }
        XCTAssertEqual(records.count, recordCount)
    }

    func testRecordingDuration() {
        // given
        let drill = createDrill()
        let duration = 78.0

        // when
        sut?.createRecord(with: drill)
        sut?.recordDuration(duration)

        // then
        guard let record = sut?.getRecords().first else { XCTFail("`getRecords()` returns nil."); return }
        XCTAssertEqual(record.recordedDuration, duration)
    }

    func testRecordingHitCount() {
        // given
        let drill = createDrill()
        let hitCount = 58

        // when
        sut?.createRecord(with: drill)
        sut?.recordHitCount(hitCount)

        // then
        guard let record = sut?.getRecords().first else { XCTFail("`getRecords()` returns nil."); return }
        XCTAssertEqual(record.hitCount, hitCount)
    }

    func testRecordingMissCount() {
        // given
        let drill = createDrill()
        let missCount = 11

        // when
        sut?.createRecord(with: drill)
        sut?.recordMissCount(missCount)

        // then
        guard let record = sut?.getRecords().first else { XCTFail("`getRecords()` returns nil."); return }
        XCTAssertEqual(record.missCount, missCount)
    }

}

extension DrillRecorderTests {

    private func createDrill(_ title: String = "", _ attempts: Int = 0, _ duration: TimeInterval = 0) -> Drill {
        return TestCoreDataHelper.createDrill(title, attempts, duration)
    }

}
