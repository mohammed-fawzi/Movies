//
//  Extentions.swift
//  MoviesTests
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import Foundation
@testable import Movies
@testable import DomainLayer
@testable import PresentationLayer

// MARK: - Helpers
extension Movie: Equatable {
    public static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
     }
}

extension Module: Equatable {
    static public func == (lhs: Module, rhs: Module) -> Bool {
        switch (lhs, rhs) {
        case let (.movieDetails(movie: a), .movieDetails(movie: b)):
          return a == b
        default:
          return false
        }
    }
}
