//
//  StubFileHandler.swift
//  MoviesTests
//
//  Created by Mohamed Fawzy on 04/08/2024.
//

import Foundation

class StubsHandler {
    
    // MARK: - For Decodable Objects
    static func getDecodableObject<T: Decodable>(fromFile fileName: String) -> T? {
        guard let data = getDataFromFile(fileName: fileName) else {return nil}
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    static func getDecodableObject<T: Decodable>(fromData data: Data) -> T? {
         try? JSONDecoder().decode(T.self, from: data)
    }
    
    static func getDecodableArray<T: Decodable>(fromFile fileName: String) -> [T]? {
        guard let data = getDataFromFile(fileName: fileName) else {return nil}
        return try? JSONDecoder().decode([T].self, from: data)
    }
    
    // MARK: - JSON
    static func getJsonFromFile(fileName: String)-> [String: Any]?{
        guard let data = getDataFromFile(fileName: fileName) else {return nil}
        return mapDataToJson(data) as? [String: Any]
    }
    
    static func getJsonArrayFromFile(fileName: String)-> [[String: Any]]?{
        guard let data = getDataFromFile(fileName: fileName) else {return nil}
        return mapDataToJson(data) as? [[String: Any]]
    }
    
    // MARK: - Raw Data
    static func getDataFromFile(fileName: String) -> Data? {
      let path = Bundle.main.path(forResource: fileName, ofType: "")
      guard let path = path else {return nil}
      let url = URL(fileURLWithPath: path)
      let data = try? Data(contentsOf: url)

      return data
    }
    
    static func mapDataToJson(_ data: Data) -> Any? {
        try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
    }
}
