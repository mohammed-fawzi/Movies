//
//  MovieStub.swift
//  MoviesTests
//
//  Created by Mohamed Fawzy on 04/08/2024.
//

import Foundation
@testable import Movies
@testable import DomainLayer

struct MovieStub {
    
    static let movie1 = Movie(id: 1,
                       title: "lord of the rings",
                       overview: "lord of the rings Overview",
                       score: 9.1234,
                       releaseDate: "2001-4-1",
                       language: "en",
                       posterUrl: "/lor.jpg",
                       genres: [28,12,16])
    
    static let movie2 = Movie(id: 2,
                       title: "Joker",
                       overview: "Joker Overview",
                       score: 8.1234,
                       releaseDate: "2024-4-1",
                       language: "en",
                       posterUrl: "/joker.jpg",
                       genres: [38,11,9])
    
    static let movie3 = Movie(id: 3,
                       title: "the dark knight rises",
                       overview: "the dark knight rises Overview",
                       score: 7.1234,
                       releaseDate: "2012-4-1",
                       language: "en",
                       posterUrl: "/darkKnight.jpg",
                       genres: [28,20,17])
}
