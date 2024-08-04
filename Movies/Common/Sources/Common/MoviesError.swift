//
//  MoviesError.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import Foundation

public enum MoviesError: Error {
    case noInternetConnection
    case invalidURL
    case invalidBodyFormat
    case invalidRequest
    case serverError
    case unknownError
    case wrongResponseFormat
    case decodeFailure
    case noCacheFound
}

// MARK: - Custom Messege
public extension MoviesError {
    public var customMessage: String {
        switch self {
        case .noInternetConnection:
            "It seems you do not have access to the internet. We will try to fetch your saved data from the last online session"
        case .serverError:
            "Internal server error please try agian later"
        default:
            "Somthing went wrong please try agian later"
        }
    }
}
