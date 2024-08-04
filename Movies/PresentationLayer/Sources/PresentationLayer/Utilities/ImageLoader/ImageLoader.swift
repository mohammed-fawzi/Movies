//
//  ImageLoader.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//


import UIKit

final class ImageLoader: ImageLoaderProtocol {
    static let shared = ImageLoader()
    private let cache: ImageCacheProtocol = ImageCache()
    
    //Shared URL Session uses useProtocolCachePolicy  which will cache fetched images by defalut in memory and on disk so we can depend on this behaviour or we can enforce the cache policy ourselfs and do not depend on the server caching policy for offline support
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = URLCache.shared
        configuration.httpCookieStorage = HTTPCookieStorage.shared
        let session = URLSession(configuration: configuration)
        return session
    }()
    
    private init(){}
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let image = cache[url] {
            completion(image)
            return
        }
        session.dataTask(with: url) { [weak self] data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                completion(nil)
                return
            }
            self?.cache[url] = image
            DispatchQueue.main.async() {
                completion(image)
            }
        }.resume()
    }
    
    func loadImage(from link: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: link) else { return }
        loadImage(from: url, completion: completion)
    }
    
}
