//
//  RunnerViewControllerTests.swift
//  PoolDrillsTests
//
//  Created by Marius on 2020-04-23.
//  Copyright © 2020 Marius. All rights reserved.
//

@testable import PoolDrills
import XCTest

final class RunnerViewControllerTests: XCTestCase {

    var sut: RunnerViewController?

    override func setUp() {
        sut = RunnerViewController(routine: createTestRoutine(), runner: MockDrillRunner())
    }

    override func tearDown() {
        sut = nil
    }

    func testNavigationItemTitleIsRoutineTitle() {
        // given
        let routine = createTestRoutine()
        let routineTitle = routine.title
        sut = RunnerViewController(routine: routine, runner: MockDrillRunner())

        // when
        _ = sut?.view

        // then
        XCTAssertEqual(routineTitle, sut?.navigationItem.title)
    }

    func testDrillsAreAddedToRunner() {
        // given
        let runner = MockDrillRunner()
        let initialDrillCount = runner.drills.count
        sut = RunnerViewController(routine: createTestRoutine(), runner: runner)

        // when
        _ = sut?.view

        // then
        XCTAssertGreaterThan(runner.drills.count, initialDrillCount)
    }

}

// MARK: - Test Helpers

extension RunnerViewControllerTests {
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

    private func createTestRoutine() -> Routine {
        let coredata = CoreDataStack()

        let routine = Routine(context: coredata.managedContext)
        routine.title = "TESTING"

        createTestDrills().forEach { routine.addToDrills($0) }

        return routine
    }

    private class MockDrillRunner: DrillRunnable {
        var drills = [Drill]()

        var selectedDrill: Drill?

        func add(_ drills: [Drill]) {
            self.drills = drills
        }

        func nextDrill() {

        }
    }
}
