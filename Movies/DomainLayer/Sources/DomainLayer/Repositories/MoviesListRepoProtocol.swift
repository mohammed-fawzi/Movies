//
//  MoviesListRepoProtocol.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import Foundation
import Common

public protocol MoviesListRepoProtocol {
    func getMovies(page: Int,
                   resultHandler: @escaping (Result<MoviesList, MoviesError>) -> Void)
}
