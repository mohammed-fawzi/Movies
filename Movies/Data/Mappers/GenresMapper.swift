//
//  GenresMapper.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import Foundation
import DomainLayer

struct GenresMapper {
   
    func map(dto: GenresDTO) -> [Genre] {
       let genres =  dto.genres?.map{ genreDTO in
            Genre(id: genreDTO.id, name: genreDTO.name)
        }
        return genres ?? []
    }
}
