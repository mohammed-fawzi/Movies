//
//  MovieDetailsUseCase.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import Foundation
import Common

public protocol MovieUseCaseProtocol {
    func getMovie(withId: Int,
                  resultHandler: @escaping (Result<MovieDetails, MoviesError>) -> Void)
}

public class MovieUseCase: MovieUseCaseProtocol {
    private let repo: MovieRepoProtocol
    
    public init(repo: MovieRepoProtocol) {
        self.repo = repo
    }
    
    public func getMovie(withId id: Int,
                         resultHandler: @escaping (Result<MovieDetails, MoviesError>) -> Void){
        repo.getMovie(withId: id, resultHandler: resultHandler)
    }
}
