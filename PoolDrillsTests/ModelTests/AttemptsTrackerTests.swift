//
//  AttemptsTrackerTests.swift
//  PoolDrillsTests
//
//  Created by Marius on 2020-05-12.
//  Copyright © 2020 Marius. All rights reserved.
//

@testable import PoolDrills
import XCTest

class AttemptsTrackerTests: XCTestCase {

    var sut: AttemptsTracker?

    override func setUp() {
        sut = AttemptsTracker()
    }

    override func tearDown() {
        sut = nil
        TestCoreDataHelper.resetContext()
    }

    func testLoadingDrillSetCorrectAttemptsLimit() {
        // given
        let attemptsLimit = 16
        let drill = createDrill(attemptsLimit)

        expectation(forNotification: .AttemptsTrackingDidUpdate, object: nil) { notification in
            return self.getAttemptsLimit(from: notification.userInfo) == attemptsLimit
        }

        // when
        sut?.load(drill)
        sut?.registerAttempt(as: false)

        // then
        waitForExpectations(timeout: 3)
    }

    func testRegisteringHit() {
        // given
        let drill = createDrill(0)
        sut?.load(drill)

        expectation(forNotification: .AttemptsTrackingDidUpdate, object: nil) { notification in
            return self.getHitCount(from: notification.userInfo) > 0
        }

        // when
        sut?.registerAttempt(as: true)

        // then
        waitForExpectations(timeout: 3)
    }

    func testRegisteringMiss() {
        // given
        let drill = createDrill(0)
        sut?.load(drill)

        expectation(forNotification: .AttemptsTrackingDidUpdate, object: nil) { notification in
            return self.getMissCount(from: notification.userInfo) > 0
        }

        // when
        sut?.registerAttempt(as: false)

        // then
        waitForExpectations(timeout: 3)
    }

    func testLoadingNewDrillResetsHitCount() {
        // given
        let drill = createDrill(0)
        sut?.load(drill)

        expectation(forNotification: .AttemptsTrackingDidUpdate, object: nil) { notification in
            return self.getHitCount(from: notification.userInfo) == 2
        }

        sut?.registerAttempt(as: true)
        sut?.registerAttempt(as: true)

        waitForExpectations(timeout: 3)

        expectation(forNotification: .AttemptsTrackingDidUpdate, object: nil) { notification in
            return self.getHitCount(from: notification.userInfo) == 1
        }

        // when
        sut?.load(drill)
        sut?.registerAttempt(as: true)

        // then
        waitForExpectations(timeout: 3)
    }

    func testLoadingNewDrillResetsMissCount() {
        // given
        let drill = createDrill(0)
        sut?.load(drill)

        expectation(forNotification: .AttemptsTrackingDidUpdate, object: nil) { notification in
            return self.getMissCount(from: notification.userInfo) == 2
        }

        sut?.registerAttempt(as: false)
        sut?.registerAttempt(as: false)

        waitForExpectations(timeout: 3)

        expectation(forNotification: .AttemptsTrackingDidUpdate, object: nil) { notification in
            return self.getMissCount(from: notification.userInfo) == 1
        }

        // when
        sut?.load(drill)
        sut?.registerAttempt(as: false)

        // then
        waitForExpectations(timeout: 3)
    }

}

extension AttemptsTrackerTests {

    private func createDrill(_ attempts: Int) -> Drill {
        return TestCoreDataHelper.createDrill("", attempts, 0)
    }

    private func getAttemptsLimit(from userInfo: [AnyHashable: Any]?) -> Int {
        guard let attemptsLimit = cast(userInfo)[.attemptsLimit] else { XCTFail("'attemptsLimit' is nil."); return 0 }
        return attemptsLimit
    }

    private func getHitCount(from userInfo: [AnyHashable: Any]?) -> Int {
        guard let hitCount = cast(userInfo)[.hitCount] else { XCTFail("'hitCount' is nil."); return 0 }
        return hitCount
    }

    private func getMissCount(from userInfo: [AnyHashable: Any]?) -> Int {
        guard let getMissCount = cast(userInfo)[.missCount] else { XCTFail("'missCount' is nil."); return 0 }
        return getMissCount
    }

    private func cast(_ userInfo: [AnyHashable: Any]?) -> [AttemptsTrackingKeys: Int] {
        guard let info = userInfo as? [AttemptsTrackingKeys: Int] else { XCTFail("'userInfo' is nil."); return [:] }
        return info
    }

}
