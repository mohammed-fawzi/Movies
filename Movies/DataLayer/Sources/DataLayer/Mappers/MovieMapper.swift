//
//  MovieMapper.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import Foundation
import DomainLayer

struct MovieMapper {
   
    func map(dto: MovieDTO) -> Movie {
        let posterUrl = dto.posterPath != nil ? "https://image.tmdb.org/t/p/w500" + dto.posterPath! : nil
        return Movie(id: dto.id,
                     title: dto.title,
                     overview: dto.overview,
                     score: dto.voteAverage,
                     releaseDate: dto.releaseDate,
                     language: dto.originalLanguage,
                     posterUrl: posterUrl,
                     genres: dto.genreIDS)
    }
}
