//
//  MoviesListStub.swift
//  MoviesTests
//
//  Created by Mohamed Fawzy on 04/08/2024.
//

import Foundation
@testable import Movies

struct MoviesListStub{
    static let list = MoviesList(page: 1,
                                 movies: [MovieStub.movie1,
                                          MovieStub.movie2,
                                          MovieStub.movie3],
                                 totalPages: 3,
                                 totalResults: 9)

}
