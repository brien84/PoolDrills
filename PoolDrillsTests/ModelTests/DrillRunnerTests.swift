//
//  DrillRunnerTests.swift
//  PoolDrillsTests
//
//  Created by Marius on 2020-04-22.
//  Copyright © 2020 Marius. All rights reserved.
//

@testable import PoolDrills
import XCTest

final class DrillRunnerTests: XCTestCase {

    var sut: DrillRunner?

    override func setUp() {
        sut = DrillRunner(with: createTestDrills())
    }

    override func tearDown() {
        sut = nil
    }

    func testSelectedDrillReturnNilIfDrillsArrayIsEmpty() {
        // given
        sut = DrillRunner()

        // when
        let drill = sut?.selectedDrill

        // then
        XCTAssertNil(drill)
    }

    func testAddingDrills() {
        // given
        sut = DrillRunner()
        // `drill` should be nil, because `sut` does not contain any drills.
        let drill = sut?.selectedDrill

        // when
        sut?.add(createTestDrills())

        // then
        XCTAssertNotEqual(drill, sut?.selectedDrill)
    }

    func testSelectingNextDrill() {
        // given
        let drill = sut?.selectedDrill

        // when
        sut?.nextDrill()

        // then
        XCTAssertNotEqual(drill, sut?.selectedDrill)
    }

    func testSelectingNextDrillIndexWillNotGoOutOfBounds() {
        // when
        for _ in 1...100 {
            sut?.nextDrill()
        }

        // then
        _ = sut?.selectedDrill
    }

}

// MARK: - Test Helpers

extension DrillRunnerTests {
    private func createTestDrills() -> [Drill] {
        var drills = [Drill]()
        let coredata = CoreDataStack()

        var drill = Drill(context: coredata.managedContext)
        drill.title = "A"
        drill.attempts = 1
        drill.duration = 10
        drills.append(drill)

        drill = Drill(context: coredata.managedContext)
        drill.title = "B"
        drill.attempts = 2
        drill.duration = 20
        drills.append(drill)

        drill = Drill(context: coredata.managedContext)
        drill.title = "C"
        drill.attempts = 3
        drill.duration = 30
        drills.append(drill)

        drill = Drill(context: coredata.managedContext)
        drill.title = "D"
        drill.attempts = 4
        drill.duration = 40
        drills.append(drill)

        drill = Drill(context: coredata.managedContext)
        drill.title = "E"
        drill.attempts = 5
        drill.duration = 50
        drills.append(drill)

        return drills
    }

    private func loadTestDrills() {

    }
}
