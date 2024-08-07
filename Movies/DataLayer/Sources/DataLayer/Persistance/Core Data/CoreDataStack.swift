//
//  CoreDataStack.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import Foundation
import CoreData

open class PersistentContainer: NSPersistentContainer {
}

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy public var persistentContainer: NSPersistentContainer = {
            let modelURL = Bundle.module.url(forResource:"Movies", withExtension: "momd")!
            let model = NSManagedObjectModel(contentsOf: modelURL)!
            let container = PersistentContainer(name:"Movies",managedObjectModel: model)
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    print("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            let context = persistentContainer.viewContext
            if context.hasChanges {
               try? context.save()
            }
        }
       
    }
}
