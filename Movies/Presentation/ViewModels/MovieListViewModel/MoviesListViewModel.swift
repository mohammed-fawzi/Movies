//
//  MoviesListViewModel.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import Foundation
import Combine
import DomainLayer
import Common

enum ListMode {
    case normal
    case search
}

class MoviesListViewModel: MoviesListViewModelProtocol {
    
    // MARK: - Properties
    private let moviesListUseCase: MoviesListUseCaseProtocol
    private let genresUseCase: GenresUseCaseProtocol
    private let coordinator: Coordinator
    private var currentPage = 1
    private var totalPages = 1
    private var mode: ListMode = .normal
    private var selectedFilter: Int? = nil {
        didSet {updateDisplayedList()}
    }
    // all movies fetched
    private var allMovies: [Movie] = [] {
        didSet {updateDisplayedList()}
    }
    // movies filterd from search
    private var searchResults: [Movie] = [] {
        didSet {reloadSubject.send(())}
    }
    // final list to be displayed for user
    private var displayMovies: [Movie] = [] {
        didSet {reloadSubject.send(())}
    }
    
    private func updateDisplayedList(){
        if let filterId = selectedFilter {
            displayMovies = allMovies.filter{
                return $0.genres?.contains(filterId) ?? false
            }
        }else {
            displayMovies = allMovies
        }
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
    private var showEmptyStateSubject = PassthroughSubject<Void,Never>()
    var showEmptyState: AnyPublisher<Void,Never> {
        return showEmptyStateSubject.eraseToAnyPublisher()
    }
    private var showGenreFiltersSubject = PassthroughSubject<[Tag],Never>()
    var showGenreFilters: AnyPublisher<[Tag],Never> {
        return showGenreFiltersSubject.eraseToAnyPublisher()
    }
    
    init(moviesListUseCase: MoviesListUseCaseProtocol,
         genresUseCase: GenresUseCaseProtocol,
         coordinator: Coordinator) {
        self.moviesListUseCase = moviesListUseCase
        self.genresUseCase = genresUseCase
        self.coordinator = coordinator
    }
}

// MARK: - Get Movies
extension MoviesListViewModel {
    private func getMovies(page: Int){
        moviesListUseCase.getMovies(page: page) { [weak self] (response: Result<MoviesList, MoviesError>) in
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
        allMovies.append(contentsOf: moviesList.movies)
        totalPages = moviesList.totalPages
        currentPage = moviesList.page
    }
    
    private func handleFetchingMoviesFailure(error: MoviesError){
        switch error {
        case .noCacheFound:
            guard displayMovies.isEmpty else {return}
            showEmptyStateSubject.send(())
        default:
            showErrorAlertSubject.send(error.customMessage)
        }
    }
}

// MARK: - Get Genres
extension MoviesListViewModel {
    private func getGenres(){
        genresUseCase.getGenres() { [weak self] (response: Result<[Genre], MoviesError>) in
            switch response {
            case .success(let genres):
                self?.handleFetchingGenresSuccess(genres: genres)
            case .failure(let error):
                self?.handleFetchingGenresFailure(error: error)
            }
        }
    }
    
    private func handleFetchingGenresSuccess(genres: [Genre]){
        let tags = genres.map { genre in
            Tag(id: genre.id, name: genre.name)
        }
        showGenreFiltersSubject.send(tags)
    }
    
    private func handleFetchingGenresFailure(error: MoviesError){
        showGenreFiltersSubject.send([])
    }
}

// MARK: - Actions
extension MoviesListViewModel {
    func viewDidLoad(){
        getMovies(page: 1)
        getGenres()
    }
    
    func didSelectCell(atIndex index: Int){
        let movie = getMovie(atIndex: index)
        coordinator.navigate(to: .movieDetails(movie: movie), withNavigationAction: .push)
    }
    
    func willShowCell(atIndex index: Int){
        guard index == displayMovies.count - 1 && currentPage < totalPages else {return}
        showFooterActivityIndicatorSubject.send(true)
        getMovies(page: currentPage + 1)
    }
    
    func tryAgainButtonDidTapped(){
        getMovies(page: 1)
        getGenres()
    }
    
    func searchButtonDidTapped(withText text: String){
        guard !text.isEmpty else {return}
        mode = .search
        searchResults = displayMovies.filter { $0.title?.lowercased().contains(text.lowercased()) ?? false}
    }
    
    func cancelSearchButtonDidTapped(){
        mode = .normal
        searchResults.removeAll()
    }
    
    func refresh() {
        searchResults.removeAll()
        displayMovies.removeAll()
        getMovies(page: 1)
    }
    
    func didSelectTag(withId id: Int){
        selectedFilter = id
    }
    
    func didDeselectTag(withId id: Int){
        selectedFilter = nil
    }
}

// MARK: - Getters
extension MoviesListViewModel {
    func getNumberOfMovies() -> Int{
        mode == .normal ? displayMovies.count : searchResults.count
    }
    
    func getMovie(atIndex index: Int) -> Movie {
        mode == .normal ? displayMovies[index] : searchResults[index]
    }
}
