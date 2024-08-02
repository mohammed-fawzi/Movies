//
//  MoviesListUseCase.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import Foundation

protocol MoviesListUseCaseProtocol {
    func getMovies(page: Int,
                   resultHandler: @escaping (Result<MoviesList, MoviesError>) -> Void)
}

class MoviesListUseCase: MoviesListUseCaseProtocol {
    private let repo: MoviesListRepoProtocol
    
    init(repo: MoviesListRepoProtocol) {
        self.repo = repo
    }
    
    func getMovies(page: Int,
                   resultHandler: @escaping (Result<MoviesList, MoviesError>) -> Void){
        repo.getMovies(page: page, resultHandler: resultHandler)
    }
}
