//
//  TestHelper.swift
//  PoolDrillsTests
//
//  Created by Marius on 2020-05-12.
//  Copyright © 2020 Marius. All rights reserved.
//

import Foundation
@testable import PoolDrills

struct TestCoreDataHelper {

    static func createDrill(_ title: String, _ attempts: Int, _ duration: Int) -> Drill {
        let coredata = CoreDataStack()

        let drill = Drill(context: coredata.managedContext)
        drill.title = ""
        drill.attempts = 0
        drill.duration = 0

        return drill
    }

    static func createRoutine(_ title: String) -> Routine {
        let coredata = CoreDataStack()

        let routine = Routine(context: coredata.managedContext)
        routine.title = title

        return routine
    }

    static func resetContext() {
        let coredata = CoreDataStack()
        coredata.managedContext.reset()
    }

}
