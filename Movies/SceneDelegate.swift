//
//  SceneDelegate.swift
//  Movies
//
//  Created by Mohamed Fawzy on 01/08/2024.
//

import UIKit
import PresentationLayer

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appDependencyContainer: AppDependencyContainer!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        setRootViewController()
    }

}

// MARK: - INIT
extension SceneDelegate {
    func setRootViewController(){
        let rootNavigationController = UINavigationController()
        appDependencyContainer = AppDependencyContainer(navigationController: rootNavigationController)
        let moviesTabBarController = appDependencyContainer.makeMoviesTabViewController()
        rootNavigationController.viewControllers = [moviesTabBarController]
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
    }
}
