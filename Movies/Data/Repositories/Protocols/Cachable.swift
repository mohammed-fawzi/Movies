//
//  Cachable.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import Foundation

protocol Cachable {
    associatedtype entity
    
    var cacheStore: ApiResponseCacheStoreProtocol {get}
    
    func saveToCache(data: Data, forEndPoint endPoint: EndPoint)
    func getFromCache(for endPoint: EndPoint,
                      resultHandler: @escaping (Result<entity, MoviesError>) -> Void)
    func mapResult(data: Data,
                   resultHandler: @escaping (Result<entity, MoviesError>) -> Void)
    
}

extension Cachable {
    func saveToCache(data: Data, forEndPoint endPoint: EndPoint){
        cacheStore.insertResponse(withData: data, forEndPoint: endPoint)
    }
    
    func getFromCache(for endPoint: EndPoint,
                      resultHandler: @escaping (Result<entity, MoviesError>) -> Void){
        guard let data = cacheStore.getResponse(forEndPoint: endPoint) else {
            resultHandler(.failure(.noCacheFound))
            return
        }
        mapResult(data: data, resultHandler: resultHandler)
    }
}
