//
//  MoviesListMapper.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import Foundation
import DomainLayer

struct MoviesListMapper {
   
    func map(dto: MoviesListDTO) -> MoviesList {
        let movieMapper = MovieMapper()
        let movies: [Movie] = dto.results?.map{movieMapper.map(dto: $0)} ?? []
        return MoviesList(page: dto.page,
                          movies: movies,
                          totalPages: dto.totalPages ?? 0,
                          totalResults: dto.totalResults ?? 0)
    }
}
