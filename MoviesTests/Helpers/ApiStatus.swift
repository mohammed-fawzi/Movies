//
//  ApiStatus.swift
//  MoviesTests
//
//  Created by Mohamed Fawzy on 04/08/2024.
//

import Foundation
@testable import Movies

enum ApiStatus {
    case success
    case failure(error: MoviesError)
}
