//
//  GenresUseCase.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import Foundation

protocol GenresUseCaseProtocol {
    func getGenres(resultHandler: @escaping (Result<[Genre], MoviesError>) -> Void)
}

class GenresUseCase: GenresUseCaseProtocol {
    private let repo: GenresRepoProtocol
    
    init(repo: GenresRepoProtocol) {
        self.repo = repo
    }
    
    func getGenres(resultHandler: @escaping (Result<[Genre], MoviesError>) -> Void){
        repo.getGenres(resultHandler: resultHandler)
    }
}
