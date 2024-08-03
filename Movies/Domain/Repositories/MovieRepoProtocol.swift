//
//  MovieRepoProtocol.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import Foundation

protocol MovieRepoProtocol {
    func getMovie(withId: Int,
                   resultHandler: @escaping (Result<MovieDetails, MoviesError>) -> Void)
}
