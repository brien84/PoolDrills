//
//  DrillTrackerTests.swift
//  PoolDrillsTests
//
//  Created by Marius on 2020-05-12.
//  Copyright © 2020 Marius. All rights reserved.
//

@testable import PoolDrills
import XCTest

class DrillTrackerTests: XCTestCase {

    var sut: DrillTracker?
    var delegate: TestDelegate?

    override func setUp() {
        delegate = TestDelegate()
        sut = DrillTracker(MockAttemptsTracker(), MockDurationTracker())
        sut?.delegate = delegate
    }

    override func tearDown() {
        delegate = nil
        sut = nil
        TestCoreDataHelper.resetContext()
    }

    func testLoadingDrillsCallsDelegate() {
        // given
        guard let delegate = delegate else { XCTFail(); return }

        let drill = createDrill()

        // when
        sut?.load([drill])

        // then
        XCTAssertTrue(delegate.didLoadDrill)
    }

    func testLoadingEmptyDrillArrayDoesNotCallDelegate() {
        // given
        guard let delegate = delegate else { XCTFail(); return }

        // when
        sut?.load([])

        // then
        XCTAssertFalse(delegate.didLoadDrill)
    }

    func testLoadingNextDrill() {
        // given
        guard let delegate = delegate else { XCTFail(); return }

        let durationTracker = MockDurationTracker(isDrillCompleted: true)
        sut = DrillTracker(MockAttemptsTracker(), durationTracker)
        sut?.delegate = delegate

        let drill0 = createDrill()
        let drill1 = createDrill()

        // when
        sut?.load([drill0, drill1])
        XCTAssertEqual(drill0, delegate.loadedDrill)
        sut?.toggle()
        XCTAssertTrue(delegate.didCompleteDrill)
        sut?.toggle()

        // then
        XCTAssertEqual(drill1, delegate.loadedDrill)
    }

    func testLoadingDrillsLoadsDrillInAttemptsTracker() {
        // given
        let attemptsTracker = MockAttemptsTracker()
        sut = DrillTracker(attemptsTracker, MockDurationTracker())

        let drill = createDrill()

        // when
        sut?.load([drill])

        // then
        XCTAssertTrue(attemptsTracker.didLoadDrill)
    }

    func testLoadingDrillsLoadsDrillInDurationTracker() {
        // given
        let durationTracker = MockDurationTracker()
        sut = DrillTracker(MockAttemptsTracker(), durationTracker)

        let drill = createDrill()

        // when
        sut?.load([drill])

        // then
        XCTAssertTrue(durationTracker.didLoadDrill)
    }

    func testStartingDrillTracking() {
        // given
        guard let delegate = delegate else { XCTFail(); return }

        let drill = createDrill()

        // when
        sut?.load([drill])
        sut?.toggle()

        // then
        XCTAssertTrue(delegate.didStartDrill)
    }

    func testPausingDrillTracking() {
        // given
        guard let delegate = delegate else { XCTFail(); return }

        let drill = createDrill()

        // when
        sut?.load([drill])
        sut?.toggle()
        XCTAssertTrue(delegate.didStartDrill)
        sut?.toggle()

        // then
        XCTAssertTrue(delegate.didPauseDrill)
    }

    func testPausingDrillTrackingPausesDurationTracker() {
        // given
        guard let delegate = delegate else { XCTFail(); return }

        let durationTracker = MockDurationTracker()
        sut = DrillTracker(MockAttemptsTracker(), durationTracker)
        sut?.delegate = delegate

        let drill = createDrill()

        // when
        sut?.load([drill])
        sut?.toggle()
        XCTAssertTrue(delegate.didStartDrill)
        sut?.toggle()
        XCTAssertTrue(delegate.didPauseDrill)

        // then
        XCTAssertTrue(durationTracker.didPause)
    }

    func testAttemptsTrackerCompletingDrill() {
        // given
        guard let delegate = delegate else { XCTFail(); return }

        let attemptsTracker = MockAttemptsTracker(isDrillCompleted: true)
        sut = DrillTracker(attemptsTracker, MockDurationTracker())
        sut?.delegate = delegate

        let drill = createDrill()

        // when
        sut?.load([drill])
        sut?.registerAttempt(as: true)

        // then
        XCTAssertTrue(delegate.didCompleteDrill)
    }

    func testDurationTrackerCompletingDrill() {
        // given
        guard let delegate = delegate else { XCTFail(); return }

        let durationTracker = MockDurationTracker(isDrillCompleted: true)
        sut = DrillTracker(MockAttemptsTracker(), durationTracker)
        sut?.delegate = delegate

        let drill = createDrill()

        // when
        sut?.load([drill])
        sut?.toggle()

        // then
        XCTAssertTrue(delegate.didCompleteDrill)
    }

    func testDelegateMethodIsCalledAfterAllDrillsAreFinished() {
        // given
        guard let delegate = delegate else { XCTFail(); return }

        let durationTracker = MockDurationTracker(isDrillCompleted: true)
        sut = DrillTracker(MockAttemptsTracker(), durationTracker)
        sut?.delegate = delegate

        let drill = createDrill()

        // when
        sut?.load([drill])
        sut?.toggle()
        XCTAssertTrue(delegate.didCompleteDrill)
        sut?.toggle()

        // then
        XCTAssertTrue(delegate.didFinishDrills)
    }

}

extension DrillTrackerTests {

    private func createDrill() -> Drill {
        return TestCoreDataHelper.createDrill("", 0, 0)
    }

    final class MockAttemptsTracker: AttemptsTracking {

        var isDrillCompleted = false

        var didLoadDrill = false

        init(isDrillCompleted: Bool = false) {
            self.isDrillCompleted = isDrillCompleted
        }

        func load(_ drill: Drill) {
            didLoadDrill = true
        }

        func registerAttempt(as successful: Bool) {
            let userInfo: [AttemptsTrackingKeys : Int] =
                [.attemptsLimit : isDrillCompleted ? 0 : 5, .hitCount : 0, .missCount : 0]

            NotificationCenter.default.post(name: .AttemptsTrackingDidUpdate, object: nil, userInfo: userInfo)
        }

    }

    final class MockDurationTracker: DurationTracking {

        var isDrillCompleted = false

        var didLoadDrill = false
        var didPause = false

        init(isDrillCompleted: Bool = false) {
            self.isDrillCompleted = isDrillCompleted
        }

        func load(_ drill: Drill) {
            didLoadDrill = true
        }

        func start() {
            let userInfo: [DurationTrackingKeys : TimeInterval] =
                [.totalDuration : 0, .drillDuration : isDrillCompleted ? 0 : 1]

            NotificationCenter.default.post(name: .DurationTrackingDidUpdate, object: nil, userInfo: userInfo)
        }

        func pause() {
            didPause = true
        }

    }

    final class TestDelegate: DrillTrackingDelegate {

        var didLoadDrill = false
        var loadedDrill: Drill?
        var didStartDrill = false
        var didPauseDrill = false
        var didCompleteDrill = false
        var didFinishDrills = false

        func drillTracking(_ tracker: DrillTracking, didLoad drill: Drill) {
            didLoadDrill = true
            loadedDrill = drill
        }

        func drillTrackingDidStart(_ tracker: DrillTracking) {
            didStartDrill = true
        }

        func drillTrackingDidPause(_ tracker: DrillTracking) {
            didPauseDrill = true
        }

        func drillTrackingDidCompleteDrill(_ tracker: DrillTracking) {
            didCompleteDrill = true
        }

        func drillTrackingDidFinishDrills(_ tracker: DrillTracking) {
            didFinishDrills = true
        }

    }
}
