//
//  Dispatching.swift
//
//
//  Created by Mohamed Fawzy on 08/08/2024.
//

import Foundation

protocol DispatchQueueType {
    func async(execute work: @escaping @convention(block) () -> Void)
}

extension DispatchQueue: DispatchQueueType {
    func async(execute work: @escaping @convention(block) () -> Void) {
            async(group: nil, qos: .unspecified, flags: [], execute: work)
        }
}
