//
//  NetworkStore.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import Foundation
import Common

public protocol NetworkStoreProtocol {
    func sendRequest(endpoint: EndPoint,
                     resultHandler: @escaping (Result<Data, MoviesError>) -> Void)
    func sendRequest<T: Decodable>(endpoint: EndPoint,
                                   resultHandler: @escaping (Result<T, MoviesError>) -> Void)
}

 public final class NetworkStore: NetworkStoreProtocol {
    private var requestBuilder: RequestBuilderProtocol
    private var errorMapper = ErrorMapper()
    
    public init(requestBuilder: RequestBuilderProtocol = RequestBuilder()) {
        self.requestBuilder = requestBuilder
    }
}

// MARK: - Using Completion Handler
public extension NetworkStore {
     func sendRequest<T: Decodable>(endpoint: EndPoint,
                                          resultHandler: @escaping (Result<T, MoviesError>) -> Void) {
        
        sendRequest(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                    resultHandler(.failure(.decodeFailure))
                    return
                }
                resultHandler(.success(decodedResponse))
            case .failure(let error):
                resultHandler(.failure(error))
            }
        }
    }
    
    func sendRequest(endpoint: EndPoint,
                            resultHandler: @escaping (Result<Data, MoviesError>) -> Void) {
        
        guard let urlRequest = requestBuilder.createRequest(endPoint: endpoint) else {
            resultHandler(.failure(.invalidURL))
            return
        }
        let urlTask = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            if let error = self?.errorMapper.checkError(error: error, response: response) {
                resultHandler(.failure(error))
                return
            }
            guard let data = data else {
                resultHandler(.failure(.wrongResponseFormat))
                return
            }
            resultHandler(.success(data))
        }
        urlTask.resume()
    }
}
