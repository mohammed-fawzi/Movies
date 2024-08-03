//
//  GenresDTO.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import Foundation

// MARK: - GenresDTO
struct GenresDTO: Codable {
    let genres: [GenreDTO]?
}

// MARK: - GenreDTO
struct GenreDTO: Codable {
    let id: Int
    let name: String
}
