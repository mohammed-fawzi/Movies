//
//  DispatchQueueMock.swift
//  MoviesTests
//
//  Created by Mohamed Fawzy on 08/08/2024.
//

import Foundation
@testable import PresentationLayer

 class DispatchQueueMock: DispatchQueueType {
    func async(execute work: @escaping @convention(block) () -> Void) {
        work()
    }
}
