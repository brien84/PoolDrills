//
//  CoreDataStack.swift
//  PoolDrills
//
//  Created by Marius on 2020-04-03.
//  Copyright © 2020 Marius. All rights reserved.
//

import CoreData
import Foundation

class CoreDataStack {

    private let modelName = "PoolDrills"

    lazy var managedContext: NSManagedObjectContext = {
        return storeContainer.viewContext
    }()

//    init(modelName: String) {
//        self.modelName = modelName
//    }

    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()

    func saveContext () {
        guard managedContext.hasChanges else { return }

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
