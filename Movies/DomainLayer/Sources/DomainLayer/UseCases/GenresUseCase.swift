//
//  GenresUseCase.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import Foundation
import Common

public protocol GenresUseCaseProtocol {
    func getGenres(resultHandler: @escaping (Result<[Genre], MoviesError>) -> Void)
}

public class GenresUseCase: GenresUseCaseProtocol {
    private let repo: GenresRepoProtocol
    
    public init(repo: GenresRepoProtocol) {
        self.repo = repo
    }
    
    public func getGenres(resultHandler: @escaping (Result<[Genre], MoviesError>) -> Void){
        repo.getGenres(resultHandler: resultHandler)
    }
}
