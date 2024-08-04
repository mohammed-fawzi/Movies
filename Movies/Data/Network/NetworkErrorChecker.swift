//
//  ErrorHandler.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import Foundation
import Common

struct ErrorMapper {
    
    func checkError(error: Error?, response: URLResponse?) -> MoviesError? {
        if let error = error {
            return transportErrorMapping(error: error)
        }
        if let response = response as? HTTPURLResponse{
            return httpResponseErrorMapping(errorCode: response.statusCode)
        }
        else {
            return .wrongResponseFormat
        }
    }
    
     private func transportErrorMapping(error: Error) -> MoviesError{
           switch error {
               case let error as NSError where error.code == NSURLErrorNotConnectedToInternet:
                   return .noInternetConnection
               case _:
                   return .unknownError
               }
       }
    
    private func httpResponseErrorMapping(errorCode:Int)->MoviesError?{
           switch(errorCode){
           case 200...299:
               return nil
           case 400...499:
               return .invalidRequest
           case 500...599:
               return .serverError
           default:
               return .unknownError
           }
       }
}
