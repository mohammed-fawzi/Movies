//
//  ImageLoaderProtocol.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import UIKit

protocol ImageLoaderProtocol{
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
    func loadImage(from link: String, completion: @escaping (UIImage?) -> Void)
}
