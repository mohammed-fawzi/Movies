//
//  NetworkStoreMock.swift
//  MoviesTests
//
//  Created by Mohamed Fawzy on 04/08/2024.
//

import Foundation
@testable import Movies
@testable import DataLayer
@testable import Common

class NetworkStoreMock: NetworkStoreProtocol {
    // MARK: - Config
    var status: ApiStatus = .success
    var data: Data?
    
    // MARK: - sendRequest
    var sendRequestIsCalled = false
    var sendRequestReceivedArguments: (endpoint: EndPoint,
                                       resultHandler: (Result<Data, MoviesError>) -> Void)?
    func sendRequest(endpoint: EndPoint, resultHandler: @escaping (Result<Data, MoviesError>) -> Void) {
        sendRequestIsCalled = true
        sendRequestReceivedArguments = (endpoint, resultHandler)
        switch status {
        case .success:
            resultHandler(.success(data ?? Data()))
        case .failure(error: let error):
            resultHandler(.failure(error))
        }
    }
}


extension NetworkStoreMock {
    
    func sendRequest<T>(endpoint: EndPoint, resultHandler: @escaping (Result<T, MoviesError>) -> Void) where T : Decodable {
        
    }
    
    func sendRequest<T>(endpoint: EndPoint) async throws -> T where T : Decodable {
        return T.self as! T
    }
}
