//
//  Coordinator.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import UIKit

enum NavigationAction {
    case push
    case present
}

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    func getViewControllerFor(_ module: Module) -> UIViewController?
    func navigate(to module: Module,withNavigationAction action: NavigationAction)
    func popToRoot(animated: Bool)
    func popBack(count: Int, animated: Bool)
    func popToViewController<T: UIViewController>(_ targetViewControllerType: T.Type, animated: Bool)
}

extension Coordinator {
 
    func navigate(to module: Module,
                  withNavigationAction action: NavigationAction) {
        guard let viewController = getViewControllerFor(module) else {return}
        switch action {
        case .push:
            if let vc = checkExistance(viewController.classForCoder) {
                navigationController.popToViewController(vc, animated: true)
            }else {
                navigationController.pushViewController(viewController, animated: true)
            }
        case .present:
            navigationController.present(viewController, animated: true, completion: nil)
        }
    }
    
    private func checkExistance(_ viewControllerType: AnyClass) -> UIViewController? {
        navigationController.viewControllers.first(where: {$0.isKind(of: viewControllerType)})
    }

}

// MARK: - POP back
extension Coordinator {
    func popToRoot(animated: Bool) {
        navigationController.popToRootViewController(animated: animated)
    }
    
    func popToViewController<T: UIViewController>(_ targetViewControllerType: T.Type, animated: Bool) {
        if let targetViewController = navigationController.viewControllers.first(where: { $0 is T }) {
            navigationController.popToViewController(targetViewController, animated: animated)
        }
    }
    
    func popBack(count: Int = 1, animated: Bool = true) {
        guard count > 0 else { return }
        let viewControllersCount = navigationController.viewControllers.count
        let targetIndex = max(0, viewControllersCount - count - 1)
        let targetViewController = navigationController.viewControllers[targetIndex]
        navigationController.popToViewController(targetViewController, animated: animated)
    }
}

// MARK: - Browser
extension Coordinator {
    func openExternalURL(url: String){
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
}
