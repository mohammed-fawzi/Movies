//
//  MoviesList.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import Foundation

public struct MoviesList {
   public let page: Int
   public let movies: [Movie]
   public let totalPages, totalResults: Int
    
    public init(page: Int, movies: [Movie], totalPages: Int, totalResults: Int) {
        self.page = page
        self.movies = movies
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}
