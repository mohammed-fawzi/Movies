//
//  GenresRepo.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import Foundation
import DomainLayer
import Common

class GenresRepo: GenresRepoProtocol, Cachable {
  
    private let networkStore: NetworkStoreProtocol
    var cacheStore: ApiResponseCacheStoreProtocol
    init(networkStore: NetworkStoreProtocol,
         cacheStore: ApiResponseCacheStoreProtocol) {
        self.networkStore = networkStore
        self.cacheStore = cacheStore
    }
    
    func getGenres(resultHandler: @escaping (Result<[Genre], MoviesError>) -> Void){
       let endPoint = GenresEndPoint()
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
extension GenresRepo {
     func mapResult(data: Data,
                          resultHandler: @escaping (Result<[Genre], MoviesError>) -> Void){
        guard let decodedResponse = try? JSONDecoder().decode(GenresDTO.self, from: data) else {
            resultHandler(.failure(.decodeFailure))
            return
        }
        
        let genresMapper = GenresMapper()
        let genresList = genresMapper.map(dto: decodedResponse)
        resultHandler(.success(genresList))
    }
}
