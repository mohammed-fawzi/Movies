//
//  MovieDetailsMapper.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import Foundation
import DomainLayer

struct MovieDetailsMapper {
   
    func map(dto: MovieDetailsDTO) -> MovieDetails {
        let genres = dto.genres?.compactMap{$0.name}
        let spokenLanguages = dto.spokenLanguages?.compactMap {$0.iso639_1}
        let details = MovieDetails(genres: genres,
                            runtime: dto.runtime,
                            homePageUrl: dto.homepage,
                            budget: dto.budget,
                            revenue: dto.revenue,
                            status: dto.status,
                            spokenLanguage: spokenLanguages,
                            score: dto.voteAverage,
                            releaseDate: dto.releaseDate)
        
        return details
    }
}
