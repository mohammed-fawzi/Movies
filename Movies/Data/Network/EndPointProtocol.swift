//
//  EndPoint.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import Foundation

public protocol EndPoint {
    var host: String { get }
    var scheme: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
    var queryParams: [String: String]? { get } // Added for query parameters
    var pathParams: [String: String]? { get }  // Added for path parameters
}

extension EndPoint {
    var scheme: String {"https"}
    var body: [String: String]? {nil}
    var queryParams: [String: String]? {nil}
    var pathParams: [String: String]? {nil}
}
