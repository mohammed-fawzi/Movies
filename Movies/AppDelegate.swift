//
//  AppDelegate.swift
//  Movies
//
//  Created by Mohamed Fawzy on 01/08/2024.
//

import UIKit
import PresentationLayer

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupTabBarItemAppearance()
        setupTabBarAppearance()
        setupNavigationBarAppearance()
        return true
    }
}


// MARK: - UI Setup
extension AppDelegate {
    private func setupTabBarItemAppearance(){
        let key = NSAttributedString.Key.font
        let font = UIFont.systemFont(ofSize: 16, weight: .bold)
        UITabBarItem.appearance().setTitleTextAttributes([key:font], for: .normal)
    }
    
    private func setupTabBarAppearance(){
        let appearance = UITabBar.appearance()
        appearance.isTranslucent = false
        appearance.backgroundColor = .background
        appearance.barTintColor = .background
        appearance.tintColor = .white
    }
    
    private func setupNavigationBarAppearance(){
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = textAttributes
    }
}
