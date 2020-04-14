//
//  CoreDataStack.swift
//  PoolDrills
//
//  Created by Marius on 2020-04-03.
//  Copyright © 2020 Marius. All rights reserved.
//

import CoreData
import Foundation

final class CoreDataStack {

    private static let modelName = "PoolDrills"

    private static let storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)

        if ProcessInfo.processInfo.arguments.contains("-TEST") {
            let persistentStoreDescription = NSPersistentStoreDescription()
            persistentStoreDescription.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [persistentStoreDescription]
        }

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()

    var managedContext: NSManagedObjectContext {
        return CoreDataStack.storeContainer.viewContext
    }

    func saveContext () {
        guard managedContext.hasChanges else { return }

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
