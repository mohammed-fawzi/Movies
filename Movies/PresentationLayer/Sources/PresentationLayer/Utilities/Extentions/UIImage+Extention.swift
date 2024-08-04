//
//  UIImage+Extention.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import UIKit

extension UIImage {
    
    // Rough estimation of how much memory image uses in bytes
        var diskSize: Int {
            guard let cgImage = cgImage else { return 0 }
            return cgImage.bytesPerRow * cgImage.height
        }
}
