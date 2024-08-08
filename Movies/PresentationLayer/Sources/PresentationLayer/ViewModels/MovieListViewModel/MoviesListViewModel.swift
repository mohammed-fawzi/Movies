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

class MoviesListViewModel: ObservableObject {
    
    // MARK: - Properties
    private let moviesListUseCase: MoviesListUseCaseProtocol
    private let genresUseCase: GenresUseCaseProtocol
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
    @Published private(set) var searchResults: [Movie] = []
    // final list to be displayed for user
    @Published private(set) var displayMovies: [Movie] = []
    @Published private(set) var genreFilters: [Tag] = []
    @Published private(set) var showFooterActivityIndicator: Bool = false
    @Published private(set) var showEmptyState: Bool = false
    @Published var showErrorAlert: Bool = false
    var errorMessage: String = ""

    private let dispatchQueue: DispatchQueueType

    // MARK: - Subjects
    private var reloadSubject = PassthroughSubject<Void,Never>()
    var reloadTable: AnyPublisher<Void,Never>{
        return reloadSubject.eraseToAnyPublisher()
    }

    init(moviesListUseCase: MoviesListUseCaseProtocol,
         genresUseCase: GenresUseCaseProtocol,
         dispatchQueue: DispatchQueueType = DispatchQueue.main) {
        self.moviesListUseCase = moviesListUseCase
        self.genresUseCase = genresUseCase
        self.dispatchQueue = dispatchQueue
        getData()
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
}

// MARK: - Get Movies
extension MoviesListViewModel {
    private func getMovies(page: Int){
        moviesListUseCase.getMovies(page: page) { [weak self] (response: Result<MoviesList, MoviesError>) in
           
            self?.dispatchQueue.async{
                self?.showFooterActivityIndicator = false
                switch response {
                case .success(let movies):
                    self?.handleFetchingMoviesSuccess(moviesList: movies)
                case .failure(let error):
                    self?.handleFetchingMoviesFailure(error: error)
                }
            }
        }
    }
    
    private func handleFetchingMoviesSuccess(moviesList: MoviesList){
        showEmptyState = false
        allMovies.append(contentsOf: moviesList.movies)
        totalPages = moviesList.totalPages
        currentPage = moviesList.page
    }
    
    private func handleFetchingMoviesFailure(error: MoviesError){
        switch error {
        case .noCacheFound:
            guard displayMovies.isEmpty else {return}
            showEmptyState = true
        default:
            errorMessage = error.customMessage
            showErrorAlert = true
        }
    }
}

// MARK: - Get Genres
extension MoviesListViewModel {
    private func getGenres(){
        genresUseCase.getGenres() { [weak self] (response: Result<[Genre], MoviesError>) in
            self?.dispatchQueue.async {
                switch response {
                case .success(let genres):
                    self?.handleFetchingGenresSuccess(genres: genres)
                case .failure(let error):
                    self?.handleFetchingGenresFailure(error: error)
                }
            }
          
        }
    }
    
    private func handleFetchingGenresSuccess(genres: [Genre]){
        let tags = genres.map { genre in
            Tag(id: genre.id, name: genre.name)
        }
        genreFilters = tags
    }
    
    private func handleFetchingGenresFailure(error: MoviesError){
        genreFilters = []
    }
}

// MARK: - Actions
extension MoviesListViewModel {
    private func getData(){
        getMovies(page: 1)
        getGenres()
    }
    
    func didShowRow(atIndex index: Int){
        guard index == displayMovies.count - 1 && currentPage < totalPages else {return}
        showFooterActivityIndicator = true
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
    
    func didTapFilter(_ id: Int,_ isSelected: Bool){
        selectedFilter = isSelected ? id : nil
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
