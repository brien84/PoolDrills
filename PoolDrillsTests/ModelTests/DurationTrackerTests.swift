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
        expectation(forNotification: .DurationTrackingDidUpdate, object: nil) { notification in
            return self.getTotalDuration(from: notification.userInfo) > 0
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
        expectation(forNotification: .DurationTrackingDidUpdate, object: nil) { notification in
            return self.getTotalDuration(from: notification.userInfo) > 4
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
        expectation(forNotification: .DurationTrackingDidUpdate, object: nil) { notification in
            if self.getTotalDuration(from: notification.userInfo) > 0 {
                self.sut?.pause()
                return true
            }

            return false
        }

        expectation(forNotification: .DurationTrackingDidUpdate, object: nil) { notification in
            return self.getTotalDuration(from: notification.userInfo) > 1
        }.isInverted = true

        // when
        sut?.start()

        // then
        waitForExpectations(timeout: 3)
    }

    func testResuming() {
        // given
        expectation(forNotification: .DurationTrackingDidUpdate, object: nil) { notification in
            if self.getTotalDuration(from: notification.userInfo) > 0 {
                self.sut?.pause()
                return true
            }

            return false
        }

        expectation(forNotification: .DurationTrackingDidUpdate, object: nil) { notification in
            return self.getTotalDuration(from: notification.userInfo) > 1
        }.isInverted = true

        // when
        sut?.start()

        // then
        waitForExpectations(timeout: 3) { _ in
            self.sut?.start()
        }

        expectation(forNotification: .DurationTrackingDidUpdate, object: nil) { notification in
            return self.getTotalDuration(from: notification.userInfo) > 2
        }

        waitForExpectations(timeout: 3)
    }

    func testDrillDurationIsCountedUpwardsWhenEqualsToZero() {
        // given
        let duration = 0
        let drill = createDrill(duration)
        sut?.load(drill)

        expectation(forNotification: .DurationTrackingDidUpdate, object: nil) { notification in
            return self.getDrillDuration(from: notification.userInfo) > 0
        }

        // when
        sut?.start()

        // then
        waitForExpectations(timeout: 3)
    }

    func testDrillDurationIsCountedDownWhenIsGreaterThanZero() {
        // given
        let duration = 10
        let drill = createDrill(duration)
        sut?.load(drill)

        expectation(forNotification: .DurationTrackingDidUpdate, object: nil) { notification in
            return self.getDrillDuration(from: notification.userInfo) < 10
        }

        // when
        sut?.start()

        // then
        waitForExpectations(timeout: 3)
    }
}

extension DurationTrackerTests {
    private func createDrill(_ duration: Int) -> Drill {
        return TestCoreDataHelper.createDrill("", 0, duration)
    }

    private func getTotalDuration(from userInfo: [AnyHashable : Any]?) -> TimeInterval {
        guard let totalDuration = cast(userInfo)[.totalDuration] else { XCTFail(); return 0 }
        return totalDuration
    }

    private func getDrillDuration(from userInfo: [AnyHashable : Any]?) -> TimeInterval {
        guard let drillDuration = cast(userInfo)[.drillDuration] else { XCTFail(); return 0 }
        return drillDuration
    }

    private func cast(_ userInfo: [AnyHashable : Any]?) -> [DurationTrackingKeys : TimeInterval] {
        guard let info = userInfo as? [DurationTrackingKeys : TimeInterval] else { XCTFail(); return [:] }
        return info
    }
}
