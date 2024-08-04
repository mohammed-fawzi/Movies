//
//  APICacheStoreMock.swift
//  MoviesTests
//
//  Created by Mohamed Fawzy on 04/08/2024.
//

import Foundation
@testable import Movies


class APICacheStoreMock: ApiResponseCacheStoreProtocol {
    
    // MARK: - config
    var status: ApiStatus = .success
    var data: Data?
    
    // MARK: - getResponse
    var getResponseIsCalled = false
    var getResponseReceivedEndpoint: EndPoint?
    func getResponse(forEndPoint endPoint: EndPoint) -> Data?{
        getResponseIsCalled = true
        getResponseReceivedEndpoint = (endPoint)
        switch status {
        case .success:
            return data
        case .failure(_):
            return nil
        }
    }
    
    // MARK: - insertResponse
    var insertResponseIsCalled = false
    var insertResponseReceivedArguments: (data: Data, endPoint: EndPoint)?
    func insertResponse(withData data: Data, forEndPoint endPoint: EndPoint){
        insertResponseIsCalled = true
        insertResponseReceivedArguments = (data,endPoint)
    }
}
