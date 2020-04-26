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
    var testDelegate: TestDelegate?

    override func setUp() {
        sut = DrillRunner(with: createTestDrills())

        testDelegate = TestDelegate()
        sut?.delegate = testDelegate
    }

    override func tearDown() {
        sut = nil
        testDelegate = nil
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
        sut?.next()

        // then
        XCTAssertNotEqual(drill, sut?.selectedDrill)
    }

    func testSelectingNextDrillIndexWillNotGoOutOfBounds() {
        // when
        for _ in 1...100 {
            sut?.next()
        }

        // then
        _ = sut?.selectedDrill
    }

    func testDrillTimeIsCountedDownIfDurationIsGreaterThanZero() {
        // given
        let drillDuration = 10.0
        let drill = createTestDrill("", 0, drillDuration)
        sut = DrillRunner(with: [drill], MockTimeTracker())
        testDelegate = TestDelegate()
        sut?.delegate = testDelegate

        // when
        sut?.start()

        // then
        XCTAssertLessThan(testDelegate!.drillTime, drillDuration)
    }

    func testDrillTimeIsCountedUpIfDurationIsEqualToZero() {
        // given
        let drillDuration = 0.0
        let drill = createTestDrill("", 0, drillDuration)
        sut = DrillRunner(with: [drill])
        testDelegate = TestDelegate()
        sut?.delegate = testDelegate

        // when
        sut?.timeable(MockTimeTracker(), didUpdate: 1.0)

        // then
        XCTAssertGreaterThan(testDelegate!.drillTime, drillDuration)
    }

    func testTotalTimeIsCountedUp() {
        // given
        testDelegate = TestDelegate()
        sut?.delegate = testDelegate
        let startTime = (testDelegate?.totalTime)!

        // when
        sut?.timeable(MockTimeTracker(), didUpdate: 1.0)

        // then
        XCTAssertGreaterThan(testDelegate!.totalTime, startTime)
    }

    func testDelegateIsInformedWhenDrillDurationIsElapsed() {
        // given
        let drillDuration = 1.0
        let drill = createTestDrill("", 0, drillDuration)
        sut = DrillRunner(with: [drill], MockTimeTracker())
        testDelegate = TestDelegate()
        sut?.delegate = testDelegate

        // when
        sut?.timeable(MockTimeTracker(), didUpdate: 1.0)

        // then
        XCTAssertTrue(testDelegate!.drillFinished)
    }
}

// MARK: - Test Helpers

extension DrillRunnerTests {

    final class TestDelegate: DrillRunnableDelegate {
        var drillTime = TimeInterval()
        var totalTime = TimeInterval()
        var drillFinished = false

        func drillRunnable(_ object: DrillRunnable, didUpdate totalTime: TimeInterval, and drillTime: TimeInterval) {
            print(totalTime)
            print(drillTime)
            self.totalTime = totalTime
            self.drillTime = drillTime
        }

        func drillRunnableDidFinishRunning(_ object: DrillRunnable, isLastDrill: Bool) {
            drillFinished = true
        }
    }

    final class MockTimeTracker: Timeable {
        var delegate: TimeableDelegate?

        func start() {
            update()
        }

        func stop() { }

        private func update() {
            delegate?.timeable(self, didUpdate: 1)
        }
    }

    private func createTestDrill(_ title: String, _ attempts: Int32, _ duration: Double) -> Drill {
        let coredata = CoreDataStack()

        let drill = Drill(context: coredata.managedContext)
        drill.title = title
        drill.attempts = attempts
        drill.duration = duration

        return drill
    }

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
}
