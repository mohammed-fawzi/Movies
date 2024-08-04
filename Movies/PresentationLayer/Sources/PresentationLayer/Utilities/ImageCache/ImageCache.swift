//
//  ImageCache.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import UIKit


final class ImageCache {
    
    private let config: Config
    
    // 1st level cache, that contains encoded images
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = config.countLimit
        return cache
    }()

    init(config: Config = Config.defaultConfig) {
        self.config = config
    }
}

extension ImageCache: ImageCacheProtocol {
    func insertImage(_ image: UIImage?, for url: URL) {
            guard let image = image else { return removeImage(for: url) }

            imageCache.setObject(image, forKey: url as AnyObject, cost: image.diskSize)
        }

        func removeImage(for url: URL) {
            imageCache.removeObject(forKey: url as AnyObject)
        }
    
        func removeAllImages() {
            imageCache.removeAllObjects()
            }

    
    func image(for url: URL) -> UIImage? {
        guard let image = imageCache.object(forKey: url as AnyObject) as? UIImage else {return nil}
        return image
      }
    
    subscript(_ key: URL) -> UIImage? {
            get {
                return image(for: key)
            }
            set {
                return insertImage(newValue, for: key)
            }
        }
}

extension ImageCache {
    struct Config {
        let countLimit: Int
        let memoryLimit: Int

        static let defaultConfig = Config(countLimit: 100, memoryLimit: 1024 * 1024 * 100) // 100 MB
    }

}
