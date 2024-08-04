//
//  MoviesListUseCase.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import Foundation
import Common

public protocol MoviesListUseCaseProtocol {
    func getMovies(page: Int,
                   resultHandler: @escaping (Result<MoviesList, MoviesError>) -> Void)
}

public class MoviesListUseCase: MoviesListUseCaseProtocol {
    private let repo: MoviesListRepoProtocol
    
    public init(repo: MoviesListRepoProtocol) {
        self.repo = repo
    }
    
    public func getMovies(page: Int,
                   resultHandler: @escaping (Result<MoviesList, MoviesError>) -> Void){
        repo.getMovies(page: page, resultHandler: resultHandler)
    }
}
