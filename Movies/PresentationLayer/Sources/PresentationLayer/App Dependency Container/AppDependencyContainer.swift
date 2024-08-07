//
//  AppDependencyContainer.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import UIKit
import SwiftUI
import DomainLayer
import DataLayer

public class AppDependencyContainer {
    
    
    public init(){}
    
    public func makeTabsView()-> MoviesTabsView{
        MoviesTabsView(dependencyContainer: self)
    }
    
    func makeListView(ofType type: MoviesListType, title: String = "")-> MoviesListView{
        let viewModel = MoviesListViewModel(moviesListUseCase: makeMoviesListUseCase(repoType: type),
                                            genresUseCase: makeGenresUseCase())
        let listView = MoviesListView(title: title,
                                      viewModel: viewModel,
                                      makeDetailsView: makeMovieDetailsView(movie:))
        return listView
     }
    
    func makeMovieDetailsView(movie: Movie)-> MovieDetailsView{
        let viewModel = MovieDetailsViewModel(useCase: makeMovieDetailsUseCase(),
                                              movie: movie)
        let view = MovieDetailsView(viewModel: viewModel)
        return view
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
