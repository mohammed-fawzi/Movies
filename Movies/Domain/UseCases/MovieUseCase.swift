//
//  MovieDetailsUseCase.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import Foundation


protocol MovieUseCaseProtocol {
    func getMovie(withId: Int,
                  resultHandler: @escaping (Result<MovieDetails, MoviesError>) -> Void)
}

class MovieUseCase: MovieUseCaseProtocol {
    private let repo: MovieRepoProtocol
    
    init(repo: MovieRepoProtocol) {
        self.repo = repo
    }
    
    func getMovie(withId id: Int,
                   resultHandler: @escaping (Result<MovieDetails, MoviesError>) -> Void){
        repo.getMovie(withId: id, resultHandler: resultHandler)
    }
}
