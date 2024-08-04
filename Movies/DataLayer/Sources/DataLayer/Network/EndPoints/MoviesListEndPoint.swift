//
//  MoviesListEndPoint.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import Foundation


enum MoviesListEndPoint: EndPoint, Equatable{
    case trending(page:Int)
    case upcoming(page:Int)
    case nowPlaying(page:Int)
}

extension MoviesListEndPoint {
    var host: String {
        return "api.themoviedb.org"
    }
    var path: String {
        switch self {
        case .trending:
            "/3/discover/movie"
        case .upcoming:
            "/3/movie/upcoming"
        case .nowPlaying:
            "/3/movie/now_playing"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .trending,.upcoming,.nowPlaying:
            return .get
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .trending,.upcoming,.nowPlaying:
            return [
                "accept": "application/json",
                "Authorization": "\(apiKey)"
            ]
        }
    }
    
    var queryParams: [String : String]?{
        switch self {
        case .trending(let page),.upcoming(let page),.nowPlaying(let page):
            return ["page": "\(page)"]
        }
    }
}
