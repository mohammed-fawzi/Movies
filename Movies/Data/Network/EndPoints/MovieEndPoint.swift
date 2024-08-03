//
//  MovieEndPoint.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import Foundation

enum MovieEndPoint: EndPoint, Equatable{
    case details(movieID: Int)
    case similar(movieID: Int, page:Int)
    case reviews(movieID: Int, page: Int)
}

extension MovieEndPoint {
    var host: String {
        return "api.themoviedb.org"
    }
    var path: String {
        switch self {
        case .details(let id):
            "/3/movie/\(id)"
        case .similar(let id,_):
            "/3/movie/\(id)/similar"
        case .reviews(let id,_):
            "/3/movie/\(id)/reviews"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .details,.similar,.reviews:
            return .get
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .details,.similar,.reviews:
            return [
                "accept": "application/json",
                "Authorization": "\(apiKey)"
            ]
        }
    }
    
    var queryParams: [String : String]?{
        switch self {
        case .details:
            return nil
        case .similar(_ , let page),.reviews(_, let page):
            return ["page": "\(page)"]
        }
    }
}
