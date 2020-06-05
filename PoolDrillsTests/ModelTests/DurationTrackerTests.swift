//
//  DurationTrackerTests.swift
//  PoolDrillsTests
//
//  Created by Marius on 2020-05-12.
//  Copyright © 2020 Marius. All rights reserved.
//

@testable import PoolDrills
import XCTest

class DurationTrackerTests: XCTestCase {

    var sut: DurationTracker?

    override func setUp() {
        let drill = createDrill(0)

        sut = DurationTracker()
        sut?.load(drill)
    }

    override func tearDown() {
        sut = nil
        TestCoreDataHelper.resetContext()
    }

    func testStarting() {
        // given
        expectation(forNotification: .durationTrackingDidUpdate, object: nil) { notification in
            return self.getRoutineTime(from: notification.userInfo) > 0
        }

        // when
        sut?.start()

        // then
        waitForExpectations(timeout: 3)
    }

    /// Test for a possible case where new `Timer`is created without invalidating the old one,
    /// so they are both executing updates, thus making the time go faster.
    func testCallingStartMultipleTimes() {
        // given
        expectation(forNotification: .durationTrackingDidUpdate, object: nil) { notification in
            return self.getRoutineTime(from: notification.userInfo) > 4
        }.isInverted = true

        // when
        sut?.start()
        sut?.start()
        sut?.start()
        sut?.start()
        sut?.start()

        // then
        waitForExpectations(timeout: 3)
    }

    func testPausing() {
        // given
        expectation(forNotification: .durationTrackingDidUpdate, object: nil) { notification in
            if self.getRoutineTime(from: notification.userInfo) > 0 {
                self.sut?.pause()
                return true
            }

            return false
        }

        expectation(forNotification: .durationTrackingDidUpdate, object: nil) { notification in
            return self.getRoutineTime(from: notification.userInfo) > 1
        }.isInverted = true

        // when
        sut?.start()

        // then
        waitForExpectations(timeout: 3)
    }

    func testResuming() {
        // given
        expectation(forNotification: .durationTrackingDidUpdate, object: nil) { notification in
            if self.getRoutineTime(from: notification.userInfo) > 0 {
                self.sut?.pause()
                return true
            }

            return false
        }

        expectation(forNotification: .durationTrackingDidUpdate, object: nil) { notification in
            return self.getRoutineTime(from: notification.userInfo) > 1
        }.isInverted = true

        // when
        sut?.start()

        // then
        waitForExpectations(timeout: 3) { _ in
            self.sut?.start()
        }

        expectation(forNotification: .durationTrackingDidUpdate, object: nil) { notification in
            return self.getRoutineTime(from: notification.userInfo) > 2
        }

        waitForExpectations(timeout: 3)
    }

    func testDrillTimeIsCountedUpwardsWhenMinutesEqualsToZero() {
        // given
        let minutes = 0
        let drill = createDrill(minutes)
        sut?.load(drill)

        expectation(forNotification: .durationTrackingDidUpdate, object: nil) { notification in
            return self.getDrillTime(from: notification.userInfo) > drill.seconds
        }

        // when
        sut?.start()

        // then
        waitForExpectations(timeout: 3)
    }

    func testDrillTimeIsCountedDownWhenMinutesIsGreaterThanZero() {
        // given
        let minutes = 1
        let drill = createDrill(minutes)
        sut?.load(drill)

        expectation(forNotification: .durationTrackingDidUpdate, object: nil) { notification in
            return self.getDrillTime(from: notification.userInfo) < drill.seconds
        }

        // when
        sut?.start()

        // then
        waitForExpectations(timeout: 3)
    }

}

extension DurationTrackerTests {
    private func createDrill(_ minutes: Int) -> Drill {
        return TestCoreDataHelper.createDrill("", 0, minutes)
    }

    private func getRoutineTime(from userInfo: [AnyHashable: Any]?) -> TimeInterval {
        guard let routineTime = cast(userInfo)[.routineTime]
            else { XCTFail("'routineTime' is nil."); return 0 }

        return routineTime
    }

    private func getDrillTime(from userInfo: [AnyHashable: Any]?) -> TimeInterval {
        guard let drillTime = cast(userInfo)[.drillTime]
            else { XCTFail("'drillTime' is nil."); return 0 }

        return drillTime
    }

    private func cast(_ userInfo: [AnyHashable: Any]?) -> [DurationTrackingKeys: TimeInterval] {
        guard let info = userInfo as? [DurationTrackingKeys: TimeInterval]
            else { XCTFail("'userInfo' is nil."); return [:] }

        return info
    }
}
