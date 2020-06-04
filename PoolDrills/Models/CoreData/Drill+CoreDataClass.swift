//
//  Drill+CoreDataClass.swift
//  PoolDrills
//
//  Created by Marius on 2020-06-04.
//  Copyright © 2020 Marius. All rights reserved.
//
//

import CoreData
import Foundation

public class Drill: NSManagedObject {

    var attempts: Int {
        get { return Int(attempts64) }
        set { attempts64 = Int64(newValue) }
    }

    var minutes: Int {
        get { return Int(duration) }
        set { duration = Int64(newValue) }
    }

    var seconds: TimeInterval {
        return TimeInterval(minutes * 60)
    }

}
