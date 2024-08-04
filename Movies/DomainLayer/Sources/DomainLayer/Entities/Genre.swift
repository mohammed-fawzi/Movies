//
//  Genres.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import Foundation

public struct Genre {
    public let id: Int
    public let name: String
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
