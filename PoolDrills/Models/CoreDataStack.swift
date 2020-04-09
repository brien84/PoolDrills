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

    private static let modelName = "PoolDrills"

    private static let model: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else { fatalError() }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else { fatalError() }

        return model
    }()

    private let storeContainer: NSPersistentContainer

    lazy var managedContext: NSManagedObjectContext = {
        return storeContainer.viewContext
    }()

    init(persistentStoreType: String = NSSQLiteStoreType) {
        let persistentStoreDescription = NSPersistentStoreDescription()

        if persistentStoreType == NSSQLiteStoreType {
            let url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("\(CoreDataStack.modelName).sqlite")
            persistentStoreDescription.url = url
        }

        persistentStoreDescription.type = persistentStoreType

        let container = NSPersistentContainer(name: CoreDataStack.modelName, managedObjectModel: CoreDataStack.model)
        container.persistentStoreDescriptions = [persistentStoreDescription]

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
   
        self.storeContainer = container
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
