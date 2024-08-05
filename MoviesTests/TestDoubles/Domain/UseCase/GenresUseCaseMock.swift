//
//  GenresUseCaseMock.swift
//  MoviesTests
//
//  Created by Mohamed Fawzy on 04/08/2024.
//

import Foundation
@testable import Movies
@testable import DomainLayer
@testable import Common

class GenresUseCaseMock: GenresUseCaseProtocol {
    
    // MARK: - Config
    var status: ApiStatus = .success
    
    // MARK: - getMovie
    var getGenresIsCalled = false

    func getGenres(resultHandler: @escaping (Result<[Genre], MoviesError>) -> Void) {
        getGenresIsCalled = true
        switch status {
        case .success:
            resultHandler(.success([]))
        case .failure(let error):
            resultHandler(.failure(error))
        }
    }
}
