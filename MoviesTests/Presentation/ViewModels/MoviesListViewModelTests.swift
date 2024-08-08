//
//  MoviesListViewModelTests.swift
//  MoviesTests
//
//  Created by Mohamed Fawzy on 04/08/2024.
//

import XCTest
import Combine
@testable import PresentationLayer
@testable import DomainLayer
@testable import Common
@testable import Movies

final class MoviesListViewModelTests: XCTestCase {
    var sut: MoviesListViewModel!
    var moviesListUseCaseMock = MoviesListUseCaseMock()
    var genresUseCaseMock = GenresUseCaseMock()
    var dispatchQueueMock = DispatchQueueMock()
    
    override func setUpWithError() throws {
        moviesListUseCaseMock.status = .success
        sut = MoviesListViewModel(moviesListUseCase: moviesListUseCaseMock,
                                  genresUseCase: genresUseCaseMock,
                                  dispatchQueue: dispatchQueueMock)
    }
}

// MARK: - Init
extension MoviesListViewModelTests {
    func testInit_fetchMoviesFirstPage(){
        //then
        XCTAssertTrue(moviesListUseCaseMock.getMoviesIsCalled)
        XCTAssertEqual(moviesListUseCaseMock.getMoviesReceivedArguments?.page, 1)
    }
    
    //as data is stubbed no need for expectation
    func testViewInit_fetchMovies_stopFooterActivityIndicator(){
        //then
        XCTAssertFalse(sut.showFooterActivityIndicator)
    }
    
    func testViewInit_fetchMoviesSuccess_appendNewMovies(){
        moviesListUseCaseMock.status = .success
        //when
        sut = MoviesListViewModel(moviesListUseCase: moviesListUseCaseMock,
                                  genresUseCase: genresUseCaseMock,
                                  dispatchQueue: dispatchQueueMock)
   
        //then
        XCTAssertEqual(sut.getNumberOfMovies(), 3)
    }
    
    
    func testViewInit_fetchMoviesFailureNoCache_showEmptyState(){
        //given
        moviesListUseCaseMock.status = .failure(error: .noCacheFound)
       
        //when
        sut = MoviesListViewModel(moviesListUseCase: moviesListUseCaseMock,
                                  genresUseCase: genresUseCaseMock,
                                  dispatchQueue: dispatchQueueMock)
        
        //then
        XCTAssertTrue(sut.showEmptyState)
    }
    
    func testInit_fetchMoviesFailureAnyError_showErorrWithNoEmptyState(){
        //given
        moviesListUseCaseMock.status = .failure(error: .noInternetConnection)

        //when
        sut = MoviesListViewModel(moviesListUseCase: moviesListUseCaseMock,
                                  genresUseCase: genresUseCaseMock,
                                  dispatchQueue: dispatchQueueMock)
        
        //then
        XCTAssertFalse(sut.showEmptyState)
        XCTAssertEqual(sut.errorMessage, MoviesError.noInternetConnection.customMessage)
    }
    
}



// MARK: - didShowRow
extension MoviesListViewModelTests {
    func testDidShowRow_notLastCell_doNothing(){
        //when
        sut.didShowRow(atIndex: 0)
        //then
        let recivedPage = moviesListUseCaseMock.getMoviesReceivedArguments?.page
        XCTAssertNotEqual(recivedPage, 2)
    }
    
    func testDidShowRow_lastCell_fetchNextPage(){
        //when
        sut.didShowRow(atIndex: 2)
        //then
        let recivedPage = moviesListUseCaseMock.getMoviesReceivedArguments?.page
        XCTAssertEqual(recivedPage, 2)
    }

}

// MARK: - searchButtonDidTapped
extension MoviesListViewModelTests {
    func testSearchButtonDidTapped_textNotEmpty_filterMovies(){
        //when
        sut.searchButtonDidTapped(withText: "Joker")
        
        //then
        XCTAssertEqual(sut.getNumberOfMovies(), 1)
        XCTAssertEqual(sut.getMovie(atIndex: 0), MovieStub.movie2)
    }
}


// MARK: - cancelSearchButtonDidTapped
extension MoviesListViewModelTests {
    func testCancelSearchButtonDidTapped_removeAllfilterd(){
        //given
        sut.searchButtonDidTapped(withText: "Joker")
        //when
      
        sut.cancelSearchButtonDidTapped()
        //then
        XCTAssertEqual(sut.getNumberOfMovies(), 3)
    }
}

// MARK: - didSelectTag
extension MoviesListViewModelTests {
    func testDidSelectTag_actionTag_filterAllActionMovies(){
        //when
        sut.didTapFilter(28, true)
        
        //then
        XCTAssertEqual(sut.getNumberOfMovies(), 2)
        XCTAssertEqual(sut.getMovie(atIndex: 0), MovieStub.movie1)
        XCTAssertEqual(sut.getMovie(atIndex: 1), MovieStub.movie3)
    }
}

// MARK: - didDeselectTag
extension MoviesListViewModelTests {
    func testDidDeselectTag_removeFilterationAndReload(){
        sut.didTapFilter(28, true)

        //when
        sut.didTapFilter(28, false)
        //then
        XCTAssertEqual(sut.getNumberOfMovies(), 3)
    }
}

// MARK: - Refresh
extension MoviesListViewModelTests {
    func testRefresh_startFromFirstPageAgain(){
        //when
        sut.refresh()
        //then
        XCTAssertTrue(moviesListUseCaseMock.getMoviesIsCalled)
        XCTAssertEqual(moviesListUseCaseMock.getMoviesReceivedArguments?.page, 1)
    }
}


// MARK: - Getters
extension MoviesListViewModelTests {
    func testGetNumberOfMovies_searchModeOn_returnSearchCount(){
        //given
        sut.searchButtonDidTapped(withText: "Joker")
        //when
        let numOfMovies = sut.getNumberOfMovies()
        //then
        XCTAssertEqual(numOfMovies, 1)
    }
    
    func testGetNumberOfMovies_searchModeOff_returnNormalCount(){
        //when
        let numOfMovies = sut.getNumberOfMovies()
        //then
        XCTAssertEqual(numOfMovies, 3)
    }
    
    func testGetMovie_searchModeOn_returnMovieFromSearchResult(){
        //given
        sut.searchButtonDidTapped(withText: "Joker")
        //when
        let movie = sut.getMovie(atIndex: 0)
        //then
        XCTAssertEqual(movie, MovieStub.movie2)
    }
}
