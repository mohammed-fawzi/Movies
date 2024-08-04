//
//  GenresEndPoint.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import Foundation

struct GenresEndPoint: EndPoint{
    var host: String {
        "api.themoviedb.org"
    }
    var path: String {
        "/3/genre/movie/list"
    }
    
    var method: RequestMethod {
        .get
    }
    
    var header: [String : String]? {
        [
            "accept": "application/json",
            "Authorization": "\(apiKey)"
        ]
    }
}
