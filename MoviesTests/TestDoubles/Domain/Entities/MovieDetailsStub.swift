//
//  MovieDetailsStub.swift
//  MoviesTests
//
//  Created by Mohamed Fawzy on 04/08/2024.
//

import Foundation
@testable import Movies
@testable import DomainLayer

struct MovieDetailsStub {
    static let movie1Details = MovieDetails(genres: ["adventure, scifi, action"],
                                            runtime: 120,
                                            homePageUrl: "http://Test.com",
                                            budget: 1000000,
                                            revenue: 2000000,
                                            status: "released",
                                            spokenLanguage: ["en","ar"],
                                            score: 9.1,
                                            releaseDate: "2024-8-4")
}
