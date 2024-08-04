//
//  GenresRepoProtocol.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import Foundation
import Common

public protocol GenresRepoProtocol {
    func getGenres(resultHandler: @escaping (Result<[Genre], MoviesError>) -> Void)
}
