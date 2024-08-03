//
//  GenresRepo.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import Foundation

class GenresRepo: GenresRepoProtocol {
    private let networkStore: NetworkStoreProtocol

    init(networkStore: NetworkStoreProtocol) {
        self.networkStore = networkStore
    }
    
    func getGenres(resultHandler: @escaping (Result<[Genre], MoviesError>) -> Void){
        networkStore.sendRequest(endpoint: GenresEndPoint()) { [weak self] result in
            switch result {
            case .success(let data):
                //TODO: Save to Cache
                self?.mapResult(data: data, resultHandler: resultHandler)
            case .failure(let error):
                resultHandler(.failure(error))
                //TODO: Get from cache
            }
        }
    }
}

// MARK: - Mapping
extension GenresRepo {
    private func mapResult(data: Data,
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
