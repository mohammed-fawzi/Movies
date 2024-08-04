//
//  MovieDetailsRepo.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import Foundation
import DomainLayer
import Common

class MovieRepo: MovieRepoProtocol, Cachable {
    private let networkStore: NetworkStoreProtocol
    let cacheStore: ApiResponseCacheStoreProtocol
    
    init(networkStore: NetworkStoreProtocol,
         cacheStore: ApiResponseCacheStoreProtocol) {
        self.networkStore = networkStore
        self.cacheStore = cacheStore
    }
    
    
    func getMovie(withId id: Int,
                   resultHandler: @escaping (Result<MovieDetails, MoviesError>) -> Void){
        let endPoint = MovieEndPoint.details(movieID: id)
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

// MARK: - Mapping
extension MovieRepo {
     func mapResult(data: Data,
                    resultHandler: @escaping (Result<MovieDetails, MoviesError>) -> Void){
        guard let decodedResponse = try? JSONDecoder().decode(MovieDetailsDTO.self, from: data) else {
            resultHandler(.failure(.decodeFailure))
            return
        }
        
        let movieDetailsMapper = MovieDetailsMapper()
        let movieDetails = movieDetailsMapper.map(dto: decodedResponse)
        resultHandler(.success(movieDetails))
    }
}

