//
//  AppDependencyContainer.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import UIKit
import DomainLayer
import DataLayer

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
        
        let viewModel = MoviesListViewModel(moviesListUseCase: makeMoviesListUseCase(repoType: repoType),
                                            genresUseCase: makeGenresUseCase(),
                                            coordinator: makeAppCoordinator())
        let vc = MoviesListViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    func makeMovieDetailsViewController(movie: Movie)-> MovieDetailsViewController{
        let viewModel = MovieDetailsViewModel(useCase: makeMovieDetailsUseCase(),
                                              movie: movie,
                                              coordinator: makeAppCoordinator() )
        let vc = MovieDetailsViewController()
        vc.viewModel = viewModel
        return vc
    }
}

// MARK: - UseCases
extension AppDependencyContainer {
    
    func makeMoviesListUseCase(repoType: MoviesListType)-> MoviesListUseCaseProtocol{
        let repo = MoviesListRepo(networkStore: makeNetworkStore(),
                                  cacheStore: makeCacheStore(),
                                  type: repoType)
        let useCase = MoviesListUseCase(repo: repo)
        return useCase
    }
    
    
    func makeGenresUseCase()-> GenresUseCaseProtocol{
        let repo = GenresRepo(networkStore: makeNetworkStore(),
                              cacheStore: makeCacheStore())
        let useCase = GenresUseCase(repo: repo)
        return useCase
    }
    
    func makeMovieDetailsUseCase() -> MovieUseCaseProtocol {
        let repo = MovieRepo(networkStore: makeNetworkStore(), cacheStore: makeCacheStore())
        let useCase = MovieUseCase(repo: repo)
        return useCase
    }
    
}

// MARK: - Stores
extension AppDependencyContainer {
    func makeNetworkStore()-> NetworkStore{
        let requestBuilder = RequestBuilder()
        let networkStore = NetworkStore(requestBuilder: requestBuilder)
        return networkStore
    }
    
    func makeCacheStore() -> ApiResponseCacheStoreProtocol {
        return MovieApiResponseCacheStore()
    }
}

// MARK: - App Coordinator
extension AppDependencyContainer {
    func makeAppCoordinator()-> Coordinator{
        let appCoordinator = AppCoordinator(navigationController: navigationController, appDependencyContainer: self)
        return appCoordinator
    }
}
