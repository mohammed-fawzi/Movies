//
//  RequestBuilder.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import Foundation

protocol RequestBuilderProtocol{
    func createRequest(endPoint: EndPoint) -> URLRequest?
}

struct RequestBuilder: RequestBuilderProtocol{
     func createRequest(endPoint: EndPoint) -> URLRequest? {
        let urlComponents = createUrlComponents(endPoint: endPoint)
        guard let url = urlComponents.url else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.allHTTPHeaderFields = endPoint.header
        if let body = endPoint.body {
            let encoder = JSONEncoder()
            request.httpBody = try? encoder.encode(body)
        }
        return request
    }
    
    private func createUrlComponents(endPoint: EndPoint) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = endPoint.scheme
        urlComponents.host = endPoint.host
        urlComponents.path = endPoint.path
        // Adding query parameters
        urlComponents.queryItems = endPoint.queryParams?.map { URLQueryItem(name: $0.key, value: $0.value) }

        // Handling path parameters
        var path = endPoint.path
        for (key, value) in endPoint.pathParams ?? [:] {
            path = path.replacingOccurrences(of: "{\(key)}", with: value)
        }
        urlComponents.path = path
        
        return urlComponents
    }
}
