//
//  Movie.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import Foundation

public struct Movie: Identifiable {
    public var id: Int
    public var title: String?
    public var overview: String?
    public var score: Double?
    public var releaseDate: String?
    public var language: String?
    public var posterUrl: String?
    public var genres: [Int]?
    
    public init(id: Int, title: String? = nil, overview: String? = nil, score: Double? = nil, releaseDate: String? = nil, language: String? = nil, posterUrl: String? = nil, genres: [Int]? = nil) {
        self.id = id
        self.title = title
        self.overview = overview
        self.score = score
        self.releaseDate = releaseDate
        self.language = language
        self.posterUrl = posterUrl
        self.genres = genres
    }
}
