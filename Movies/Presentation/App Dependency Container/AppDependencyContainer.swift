//
//  AppDependencyContainer.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import UIKit

class AppDependencyContainer {
    let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func makeMoviesTabViewController()-> MoviesTabBarViewController{
        let tabBarController = MoviesTabBarViewController()
        tabBarController.appDependencyContainer = self
        return tabBarController
    }
    
    func makeTrendingMoviesListViewController() -> MoviesListViewController {
        makeMovieListViewController(repoType: .trending)
    }
    
    func makeUpcomingMoviesListViewController() -> MoviesListViewController {
        makeMovieListViewController(repoType: .upcoming)
    }
    
    func makeNowPlayingMoviesListViewController() -> MoviesListViewController {
        makeMovieListViewController(repoType: .nowPlaying)
    }
    
    func makeMovieListViewController(repoType: MoviesListType)-> MoviesListViewController{
        let requestBuilder = RequestBuilder()
        let networkStore = NetworkStore(requestBuilder: requestBuilder)
        let repo = MoviesListRepo(networkStore: networkStore,
                                  type: repoType)
        let useCase = MoviesListUseCase(repo: repo)
        let appCoordinator = AppCoordinator(navigationController: navigationController, appDependencyContainer: self)
        let viewModel = MoviesListViewModel(useCase: useCase, coordinator: appCoordinator)
        let vc = MoviesListViewController()
        vc.viewModel = viewModel
        return vc
    }
}
