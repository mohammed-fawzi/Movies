//
//  MoviesListViewModelProtocol.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import Foundation
import Combine

protocol MoviesListViewModelProtocol {
    var reloadTable: AnyPublisher<Void,Never> {get}
    var showFooterActivityIndicator: AnyPublisher<Bool,Never> {get}
    var showErrorAlert: AnyPublisher<String,Never> {get}
    var showEmptyState: AnyPublisher<Void,Never> {get}
    var showGenreFilters: AnyPublisher<[Tag],Never> {get}
    
    func viewDidLoad()
    func willShowCell(atIndex index: Int)
    func didSelectCell(atIndex index: Int)
    func getNumberOfMovies() -> Int
    func getMovie(atIndex index: Int) -> Movie
    func tryAgainButtonDidTapped()
    func searchButtonDidTapped(withText: String)
    func cancelSearchButtonDidTapped()
    func didSelectTag(withId id: Int)
    func didDeselectTag(withId id: Int)
    func refresh()
}
