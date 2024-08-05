//
//  MoviesListDTOStub.swift
//  MoviesTests
//
//  Created by Mohamed Fawzy on 04/08/2024.
//

import Foundation
@testable import Movies
@testable import DataLayer

struct MoviesListDTOStub{
    static let rawData = StubsHandler.getDataFromFile(fileName: "MoviesListResponse.json")
    static let moviesListDTO: MoviesListDTO? = StubsHandler.getDecodableObject(fromFile: "MoviesListResponse.json")
}
