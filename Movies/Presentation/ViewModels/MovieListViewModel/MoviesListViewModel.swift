//
//  MoviesListViewModel.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import Foundation
import Combine



class MoviesListViewModel: MoviesListViewModelProtocol {
    
    // MARK: - Properties
    private let useCase: MoviesListUseCaseProtocol
    private let coordinator: Coordinator
    private var currentPage = 1
    private var totalPages = 1

    private var movies: [Movie] = [] {
        didSet {reloadSubject.send(())}
    }
    
    // MARK: - Subjects
    private var reloadSubject = PassthroughSubject<Void,Never>()
    var reloadTable: AnyPublisher<Void,Never>{
        return reloadSubject.eraseToAnyPublisher()
    }
    private var showFooterActivityIndicatorSubject = PassthroughSubject<Bool,Never>()
    var showFooterActivityIndicator: AnyPublisher<Bool,Never> {
        return showFooterActivityIndicatorSubject.eraseToAnyPublisher()
    }
    private var showErrorAlertSubject = PassthroughSubject<String,Never>()
    var showErrorAlert: AnyPublisher<String,Never> {
        return showErrorAlertSubject.eraseToAnyPublisher()
    }

    init(useCase: MoviesListUseCaseProtocol, coordinator: Coordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
}

// MARK: - Get Movies
extension MoviesListViewModel {
    private func getMovies(page: Int){
        useCase.getMovies(page: page) { [weak self] (response: Result<MoviesList, MoviesError>) in
            self?.showFooterActivityIndicatorSubject.send(false)
            switch response {
            case .success(let movies):
                self?.handleFetchingMoviesSuccess(moviesList: movies)
            case .failure(let error):
                self?.handleFetchingMoviesFailure(error: error)
            }
        }
    }
    
    private func handleFetchingMoviesSuccess(moviesList: MoviesList){
        movies.append(contentsOf: moviesList.movies)
        totalPages = moviesList.totalPages
        currentPage = moviesList.page
    }
    
    private func handleFetchingMoviesFailure(error: MoviesError){
            showErrorAlertSubject.send(error.customMessage)
    }
}

// MARK: - Actions
extension MoviesListViewModel {
    func viewDidLoad(){
        getMovies(page: 1)
    }
    
    func didSelectCell(atIndex index: Int){
       //TODO: navigate to details screen
    }
    
    func willShowCell(atIndex index: Int){
        guard index == movies.count - 1 && currentPage < totalPages else {return}
        showFooterActivityIndicatorSubject.send(true)
        getMovies(page: currentPage + 1)
    }
    
}

// MARK: - Getters
extension MoviesListViewModel {
    func getNumberOfMovies() -> Int{
         movies.count
    }
    
    func getMovie(atIndex index: Int) -> Movie {
        movies[index]
    }
}
