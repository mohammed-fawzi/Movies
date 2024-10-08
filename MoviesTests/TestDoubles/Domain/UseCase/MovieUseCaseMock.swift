//
//  MovieUseCaseMock.swift
//  MoviesTests
//
//  Created by Mohamed Fawzy on 04/08/2024.
//

import Foundation
@testable import Movies

class MovieUseCaseMock: MovieUseCaseProtocol {
    // MARK: - Config
    var status: ApiStatus = .success
    
    // MARK: - getMovie
    var getMovieIsCalled = false
    var getMovieReceivedArguments: (id: Int,
                                     resultHandler: (Result<MovieDetails, MoviesError>)->Void)?
    func getMovie(withId id: Int,
                  resultHandler: @escaping (Result<MovieDetails, MoviesError>) -> Void){
        getMovieIsCalled = true
        getMovieReceivedArguments = (id,resultHandler)
        switch status {
        case .success:
            resultHandler(.success(MovieDetailsStub.movie1Details))
        case .failure(let error):
            resultHandler(.failure(error))
        }
    }
}
