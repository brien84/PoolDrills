//
//  TimeTrackerTests.swift
//  PoolDrillsTests
//
//  Created by Marius on 2020-04-21.
//  Copyright © 2020 Marius. All rights reserved.
//

@testable import PoolDrills
import XCTest

class TimeTrackerTests: XCTestCase {

    var sut: TimeTracker?
    var testDelegate: TestDelegate?

    override func setUp() {
        sut = TimeTracker()

        testDelegate = TestDelegate()
        sut?.delegate = testDelegate
    }

    override func tearDown() {
        sut = nil
        testDelegate = nil
    }

    func testStartingTimeTracker() {
        // given
        guard let testDelegate = testDelegate else { return XCTFail("testDelegate is nil") }
        let startTime = testDelegate.time
        let waitTime: TimeInterval = 1.0
        let expectation = self.expectation(description: "Wait for \(waitTime) seconds to pass.")

        // when
        sut?.start()

        wait(for: waitTime, fulfilling: expectation)

        // then
        let endTime = testDelegate.time
        XCTAssertLessThan(startTime, endTime)
    }

    /// Test for a possible case where new `Timer`is created without invalidating the old one,
    /// so they are both calling selector method, thus making the time go faster.
    func testStartingTimeTrackerMultipleTimes() {
        // given
        guard let testDelegate = testDelegate else { return XCTFail("testDelegate is nil") }
        let waitTime: TimeInterval = 2.0
        let expectation = self.expectation(description: "Wait for \(waitTime) seconds to pass.")

        // when
        sut?.start()
        sut?.start()
        sut?.start()
        sut?.start()
        sut?.start()

        wait(for: waitTime, fulfilling: expectation)

        // then
        let endTime = testDelegate.time
        XCTAssertEqual(endTime, waitTime)
    }

    func testStoppingTimeTracker() {
        // given
        guard let testDelegate = testDelegate else { return XCTFail("testDelegate is nil") }
        let waitTime: TimeInterval = 1.0
        let startTime = testDelegate.time
        let expectation = self.expectation(description: "Wait for \(waitTime) seconds to pass.")

        // when
        sut?.start()
        sut?.stop()

        wait(for: waitTime, fulfilling: expectation)

        // then
        let endTime = testDelegate.time
        XCTAssertEqual(startTime, endTime)
    }

    func testResumingTimeTracker() {
        // given
        guard let testDelegate = testDelegate else { return XCTFail("testDelegate is nil") }
        let waitTime: TimeInterval = 1.0
        let expectation0 = self.expectation(description: "Wait for \(waitTime) seconds to pass.")
        let expectation1 = self.expectation(description: "Wait for \(waitTime) seconds to pass.")
        let expectation2 = self.expectation(description: "Wait for \(waitTime) seconds to pass.")

        // when
        sut?.start()

        wait(for: waitTime, fulfilling: expectation0)

        sut?.stop()

        wait(for: waitTime, fulfilling: expectation1)

        sut?.start()

        wait(for: waitTime, fulfilling: expectation2)

        // then
        let endTime = testDelegate.time
        XCTAssertEqual(endTime, waitTime * 2)
    }

    // MARK: - Test Helpers

    func wait(for time: TimeInterval, fulfilling expectation: XCTestExpectation) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: time + 0.5)
    }

    final class TestDelegate: TimeableDelegate {
        var time: TimeInterval = 0

        func timeable(_ object: Timeable, didUpdate time: TimeInterval) {
            self.time = time
        }
    }

}
