//
//  Drill.swift
//  PoolDrills
//
//  Created by Marius on 2020-03-07.
//  Copyright © 2020 Marius. All rights reserved.
//

import CoreData
import UIKit

final class Drill: NSManagedObject {

    convenience init?(name: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
        self.name = name

        guard (try? context.save()) != nil else { return nil }
    }

}
