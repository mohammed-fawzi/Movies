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
        let appCoordinator = AppCoordinator(navigationController: navigationController, appDependencyContainer: self)
        let viewModel = MoviesListViewModel(moviesListUseCase: makeMoviesListUseCase(repoType: repoType),
                                            genresUseCase: makeGenresUseCase(),
                                            coordinator: appCoordinator)
        let vc = MoviesListViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    func makeMoviesListUseCase(repoType: MoviesListType)-> MoviesListUseCaseProtocol{
        let repo = MoviesListRepo(networkStore: makeNetworkStore(),type: repoType)
        let useCase = MoviesListUseCase(repo: repo)
        return useCase
    }
    
    func makeGenresUseCase()-> GenresUseCaseProtocol{
        let repo = GenresRepo(networkStore: makeNetworkStore())
        let useCase = GenresUseCase(repo: repo)
        return useCase
    }
    
    func makeNetworkStore()-> NetworkStore{
        let requestBuilder = RequestBuilder()
        let networkStore = NetworkStore(requestBuilder: requestBuilder)
        return networkStore
    }
}
