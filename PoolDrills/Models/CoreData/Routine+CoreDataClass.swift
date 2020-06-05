//
//  Routine+CoreDataClass.swift
//  PoolDrills
//
//  Created by Marius on 2020-06-04.
//  Copyright © 2020 Marius. All rights reserved.
//
//

import CoreData
import Foundation

public class Routine: NSManagedObject {

    var containsDrills: Bool {
        return (drills?.count ?? 0) > 0
    }

}
