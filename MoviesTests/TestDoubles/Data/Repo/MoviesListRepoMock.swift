//
//  MoviesListRepoMock.swift
//  MoviesTests
//
//  Created by Mohamed Fawzy on 04/08/2024.
//

import Foundation
@testable import Movies
@testable import DomainLayer
@testable import Common

class MoviesListRepoMock: MoviesListRepoProtocol {
    // MARK: - Config
    var status: ApiStatus = .success
    
    // MARK: - getMovies
    var getMoviesIsCalled = false
    var getMoviesReceivedArguments: (page: Int,
                                     resultHandler: (Result<MoviesList, MoviesError>)->Void)?
    
    func getMovies(page: Int,
                   resultHandler: @escaping (Result<MoviesList, MoviesError>) -> Void){
        getMoviesIsCalled = true
        getMoviesReceivedArguments = (page,resultHandler)
        switch status {
        case .success:
            resultHandler(.success(MoviesListStub.list))
        case .failure(let error):
            resultHandler(.failure(error))
        }
    }
}
