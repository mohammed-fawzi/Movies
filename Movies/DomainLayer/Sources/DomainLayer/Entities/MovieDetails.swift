//
//  MovieDetails.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import Foundation

public struct MovieDetails {
    public let genres: [String]?
    public let runtime: Int?
    public let homePageUrl: String?
    public let budget: Int?
    public let revenue: Int?
    public let status: String?
    public let spokenLanguage: [String]?
    public let score: Double?
    public let releaseDate: String?
    
    public init(genres: [String]?, runtime: Int?, homePageUrl: String?, budget: Int?, revenue: Int?, status: String?, spokenLanguage: [String]?, score: Double?, releaseDate: String?) {
        self.genres = genres
        self.runtime = runtime
        self.homePageUrl = homePageUrl
        self.budget = budget
        self.revenue = revenue
        self.status = status
        self.spokenLanguage = spokenLanguage
        self.score = score
        self.releaseDate = releaseDate
    }
}
