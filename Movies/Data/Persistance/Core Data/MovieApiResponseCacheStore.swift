//
//  MovieApiResponseCacheStore.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import Foundation
import CoreData

protocol ApiResponseCacheStoreProtocol{
    func getResponse(forEndPoint endPoint: EndPoint) -> Data?
    func insertResponse(withData data: Data, forEndPoint endPoint: EndPoint)
}

class MovieApiResponseCacheStore: ApiResponseCacheStoreProtocol{
    private let coreDataStore = CoreDataStore<CDApiResponse>()
    private let requestBuilder = RequestBuilder()
    
    func getResponse(forEndPoint endPoint: EndPoint) -> Data? {
        guard let urlRequest = requestBuilder.createRequest(endPoint: endPoint),
              let urlString = urlRequest.url?.absoluteString else {return nil}
        return getResponse(WithId: urlString)
    }
    
    func insertResponse(withData data: Data, forEndPoint endPoint: EndPoint) {
        guard let urlRequest = requestBuilder.createRequest(endPoint: endPoint),
              let urlString = urlRequest.url?.absoluteString else {return}
        insertResponse(withData: data, andID: urlString)
    }
}


extension MovieApiResponseCacheStore {
    private func insertResponse(withData data: Data, andID id: String){
       deleteResponse(withId: id)
       let newResponse = CDApiResponse(context: coreDataStore.context)
       newResponse.id = id
       newResponse.date = Date()
       newResponse.data = data
       coreDataStore.insert(object: newResponse)
   }
   
   private func getResponse(WithId id: String) -> Data? {
       let predicate = NSPredicate(format: "id = %@", id)
       let response = try? coreDataStore.getBy(predicate: predicate, limit: 1)
       return response?.first?.data
   }
   
   private func deleteResponse(withId id: String){
       let predicate = NSPredicate(format: "id = %@", id)
       try? coreDataStore.deleteBy(predicate: predicate, limit: 1)
   }
}
