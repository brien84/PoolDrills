//
//  Stopwatch.swift
//  PoolDrills
//
//  Created by Marius on 2020-04-18.
//  Copyright © 2020 Marius. All rights reserved.
//

import Foundation

protocol TimeableDelegate: AnyObject {
    func timeable(_ object: Timeable, didUpdate time: TimeInterval)
}

protocol Timeable {
    var delegate: TimeableDelegate? { get set }

    func start()
    func stop()
}

final class TimeTracker: Timeable {

    weak var delegate: TimeableDelegate?

    private var timer: Timer?
    private var seconds: TimeInterval = 0

    func start() {
        guard timer == nil else { return }

        timer = createTimer()
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func update() {
        seconds += 1

        delegate?.timeable(self, didUpdate: seconds)
    }

    private func createTimer() -> Timer {
        let timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: (#selector(update)),
                                         userInfo: nil,
                                         repeats: true)
        timer.tolerance = 0.1
        RunLoop.current.add(timer, forMode: .common)

        return timer
    }
}
