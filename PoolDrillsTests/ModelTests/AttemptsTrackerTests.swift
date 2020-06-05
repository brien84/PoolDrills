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

    func testLoadingDrillSetsCorrectAttemptsCount() {
        // given
        let attempts = Int.random(in: 0...100)
        let drill = createDrill(attempts)

        expectation(forNotification: .attemptsTrackingDidUpdate, object: nil) { notification in
            return self.getAttempts(from: notification.userInfo) == attempts
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

        expectation(forNotification: .attemptsTrackingDidUpdate, object: nil) { notification in
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

        expectation(forNotification: .attemptsTrackingDidUpdate, object: nil) { notification in
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

        expectation(forNotification: .attemptsTrackingDidUpdate, object: nil) { notification in
            return self.getHitCount(from: notification.userInfo) == 2
        }

        sut?.registerAttempt(as: true)
        sut?.registerAttempt(as: true)

        waitForExpectations(timeout: 3)

        expectation(forNotification: .attemptsTrackingDidUpdate, object: nil) { notification in
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

        expectation(forNotification: .attemptsTrackingDidUpdate, object: nil) { notification in
            return self.getMissCount(from: notification.userInfo) == 2
        }

        sut?.registerAttempt(as: false)
        sut?.registerAttempt(as: false)

        waitForExpectations(timeout: 3)

        expectation(forNotification: .attemptsTrackingDidUpdate, object: nil) { notification in
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

    private func getAttempts(from userInfo: [AnyHashable: Any]?) -> Int {
        guard let attempts = cast(userInfo)[.attempts]
            else { XCTFail("'attemptsLimit' is nil."); return 0 }

        return attempts
    }

    private func getHitCount(from userInfo: [AnyHashable: Any]?) -> Int {
        guard let hitCount = cast(userInfo)[.hitCount]
            else { XCTFail("'hitCount' is nil."); return 0 }

        return hitCount
    }

    private func getMissCount(from userInfo: [AnyHashable: Any]?) -> Int {
        guard let missCount = cast(userInfo)[.missCount]
            else { XCTFail("'missCount' is nil."); return 0 }

        return missCount
    }

    private func cast(_ userInfo: [AnyHashable: Any]?) -> [AttemptsTrackingKeys: Int] {
        guard let info = userInfo as? [AttemptsTrackingKeys: Int]
            else { XCTFail("'userInfo' is nil."); return [:] }

        return info
    }
}
