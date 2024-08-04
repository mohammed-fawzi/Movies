//
//  MoviesListRepo.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import Foundation
import Combine
import DomainLayer
import Common

public enum MoviesListType{
    case trending, nowPlaying, upcoming
}


public class MoviesListRepo: MoviesListRepoProtocol, Cachable {
    private let networkStore: NetworkStoreProtocol
    var cacheStore: ApiResponseCacheStoreProtocol
    private let type: MoviesListType

    public init(networkStore: NetworkStoreProtocol,
         cacheStore: ApiResponseCacheStoreProtocol,
         type: MoviesListType) {
        self.networkStore = networkStore
        self.cacheStore = cacheStore
        self.type = type
    }
    
    public func getMovies(page: Int,
                   resultHandler: @escaping (Result<MoviesList, MoviesError>) -> Void){
        let endPoint = getEndPoint(withPage: page)
        networkStore.sendRequest(endpoint: endPoint) { [weak self] result in
            switch result {
            case .success(let data):
                self?.saveToCache(data: data, forEndPoint: endPoint)
                self?.mapResult(data: data, resultHandler: resultHandler)
            case .failure(let error):
                resultHandler(.failure(error))
                self?.getFromCache(for: endPoint, resultHandler: resultHandler)
            }
        }
    }
}

// MARK: - End Point
extension MoviesListRepo {
    private func getEndPoint(withPage page: Int)-> EndPoint{
        var endpoint: EndPoint
        switch type {
        case .trending:
            endpoint = MoviesListEndPoint.trending(page: page)
        case .nowPlaying:
            endpoint = MoviesListEndPoint.nowPlaying(page: page)
        case .upcoming:
            endpoint = MoviesListEndPoint.upcoming(page: page)
        }
        return endpoint
    }
}

// MARK: - Mapping
extension MoviesListRepo {
     func mapResult(data: Data,
                    resultHandler: @escaping (Result<MoviesList, MoviesError>) -> Void){
        guard let decodedResponse = try? JSONDecoder().decode(MoviesListDTO.self, from: data) else {
            resultHandler(.failure(.decodeFailure))
            return
        }
        
        let moviesListMapper = MoviesListMapper()
        let moviesList = moviesListMapper.map(dto: decodedResponse)
        resultHandler(.success(moviesList))
    }
}
