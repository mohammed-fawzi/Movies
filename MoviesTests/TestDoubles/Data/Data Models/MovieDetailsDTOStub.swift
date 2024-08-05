//
//  MovieDetailsDTOStub.swift
//  MoviesTests
//
//  Created by Mohamed Fawzy on 04/08/2024.
//

import Foundation
@testable import Movies
@testable import DataLayer

struct MovieDetailsDTOStub{
    static let rawData = StubsHandler.getDataFromFile(fileName: "MovieDetailsResponse.json")
    static let moviesListDTO: MoviesListDTO? = StubsHandler.getDecodableObject(fromFile: "MovieDetailsResponse.json")
}
