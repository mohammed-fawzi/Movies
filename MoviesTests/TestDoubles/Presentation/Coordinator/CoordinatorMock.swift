//
//  CoordinatorMock.swift
//  MoviesTests
//
//  Created by Mohamed Fawzy on 04/08/2024.
//

import UIKit
@testable import PresentationLayer
@testable import Movies

class CoordinatorMock: Coordinator {
    var navigationController: UINavigationController = UINavigationController()
    
    // MARK: - navigate
    var navigateIsCalled = false
    var navigateReceivedArguments: (module: Module, action: NavigationAction)?
    func navigate(to module: Module, withNavigationAction action: NavigationAction) {
        navigateIsCalled = true
        navigateReceivedArguments = (module,action)
    }
    
    // MARK: - openExternalURL
    var openExternalURLIsCalled = false
    var openExternalURLReceivedUrl: String?
    func openExternalURL(url: String){
        openExternalURLIsCalled = true
        openExternalURLReceivedUrl = url
        
    }
}

extension CoordinatorMock {
    func getViewControllerFor(_ module: Module) -> UIViewController? {return nil}
}
