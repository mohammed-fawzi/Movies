//
//  AppCoordinator.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import UIKit

enum Module{
    case trendingMovies
    case upcomingMovies
    case nowPlayingMoives
}
class AppCoordinator: Coordinator {

    var navigationController: UINavigationController
    var appDependencyContainer: AppDependencyContainer
    init(navigationController: UINavigationController, appDependencyContainer: AppDependencyContainer) {
        self.navigationController = navigationController
        self.appDependencyContainer = appDependencyContainer
    }
    
    func getViewControllerFor(_ module: Module) -> UIViewController? {
        let vc: UIViewController
        switch module {
        case .trendingMovies:
            vc = appDependencyContainer.makeTrendingMoviesListViewController()
        case .upcomingMovies:
            vc = appDependencyContainer.makeUpcomingMoviesListViewController()
        case .nowPlayingMoives:
            vc = appDependencyContainer.makeNowPlayingMoviesListViewController()
        }
        return vc
    }
    
    
}
