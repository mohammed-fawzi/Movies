//
//  CoreDataStore.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import Foundation
import CoreData


class CoreDataStore<T: NSManagedObject>: StorageStoreProtocol{
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.viewContext) {
        self.context = context
    }
    
    func getAll() throws -> [T] {
        let request = T.fetchRequest()
        return try context.fetch(request) as? [T] ?? []
    }
    
    func getBy(predicate: NSPredicate, limit: Int?) throws -> [T] {
        let request = T.fetchRequest()
        request.predicate = predicate
        if let limit = limit {request.fetchLimit = limit}
        return try context.fetch(request) as? [T] ?? []
    }
    
    func insert(object: T) {
        context.insert(object)
        CoreDataStack.shared.saveContext()
    }
    
    func delete(object: T) {
        context.delete(object)
        CoreDataStack.shared.saveContext()
    }
    
    func deleteBy(predicate: NSPredicate, limit: Int?) throws {
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = predicate
        if let limit = limit {fetchRequest.fetchLimit = limit}
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
    }
}
