//
//  StorageContext.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import Foundation

protocol StorageStoreProtocol {
    associatedtype DBEntity
    
    func getAll() throws -> [DBEntity]
    func getBy(predicate: NSPredicate, limit: Int?) throws -> [DBEntity]
    func insert(object: DBEntity)
    func delete(object: DBEntity)
    func deleteBy(predicate: NSPredicate, limit: Int?) throws
}
