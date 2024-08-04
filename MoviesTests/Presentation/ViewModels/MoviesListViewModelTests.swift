//
//  MoviesListViewModelTests.swift
//  MoviesTests
//
//  Created by Mohamed Fawzy on 04/08/2024.
//

import XCTest
import Combine
@testable import Movies

final class MoviesListViewModelTests: XCTestCase {
    var sut: MoviesListViewModel!
    var moviesListUseCaseMock = MoviesListUseCaseMock()
    var genresUseCaseMock = GenresUseCaseMock()
    var coordinatorMock = CoordinatorMock()
    
    var cancellables: Set<AnyCancellable>!
    override func setUpWithError() throws {
        cancellables = []
        sut = MoviesListViewModel(moviesListUseCase: moviesListUseCaseMock,
                                  genresUseCase: genresUseCaseMock,
                                  coordinator: coordinatorMock)
    }
}

// MARK: - ViewDidLoad
extension MoviesListViewModelTests {
    func testViewDidLoad_fetchMoviesFirstPage(){
        //when
        sut.viewDidLoad()
        //then
        XCTAssertTrue(moviesListUseCaseMock.getMoviesIsCalled)
        XCTAssertEqual(moviesListUseCaseMock.getMoviesReceivedArguments?.page, 1)
    }
    
    //as data is stubbed no need for expectation
    func testViewDidLoad_fetchMovies_stopFooterActivityIndicator(){
        //given
        var showSignal: Bool = true
        sut.showFooterActivityIndicator.sink { show in
            showSignal = show
        }.store(in: &cancellables)
        
        //when
        sut.viewDidLoad()
        
        //then
        XCTAssertFalse(showSignal)
    }
    
    func testViewDidLoad_fetchMoviesSuccess_appendNewMoviesAndReload(){
        //given
        moviesListUseCaseMock.status = .success

        //when
        var reload = false
        sut.reloadTable.sink { show in
            reload = true
        }.store(in: &cancellables)
        sut.viewDidLoad()
        
        //then
        XCTAssertEqual(sut.getNumberOfMovies(), 3)
        XCTAssertTrue(reload)
    }
    
    
    func testViewDidLoad_fetchMoviesFailureNoCache_showEmptyState(){
        //given
        moviesListUseCaseMock.status = .failure(error: .noCacheFound)

        //when
        var showEmptyState = false
        sut.showEmptyState.sink { _ in
            showEmptyState = true
        }.store(in: &cancellables)
        sut.viewDidLoad()
        
        //then
        XCTAssertTrue(showEmptyState)
    }
    
    func testViewDidLoad_fetchMoviesFailureAnyError_showErorrWithNoEmptyState(){
        //given
        moviesListUseCaseMock.status = .failure(error: .noInternetConnection)

        //when
        var showEmptyState = true
        sut.showErrorAlert.sink { _ in
            showEmptyState = false
        }.store(in: &cancellables)
        
        var recivedMessage = ""
        sut.showErrorAlert.sink { message in
            recivedMessage = message
        }.store(in: &cancellables)
        sut.viewDidLoad()
        
        //then
        XCTAssertFalse(showEmptyState)
        XCTAssertEqual(recivedMessage, MoviesError.noInternetConnection.customMessage)
    }
    
}

// MARK: - didSelectCell
extension MoviesListViewModelTests {
    func testDidSelectCell_navigateToDetailsScreen(){
        //given
        moviesListUseCaseMock.status = .success
        sut.viewDidLoad()
        //when
        sut.didSelectCell(atIndex: 0)
        //then
        let recivedModule = coordinatorMock.navigateReceivedArguments?.module
        let expectedModule = Module.movieDetails(movie: MovieStub.movie1)
        XCTAssertTrue(coordinatorMock.navigateIsCalled)
        XCTAssertEqual(recivedModule, expectedModule)
    }
}


// MARK: - willShowCell
extension MoviesListViewModelTests {
    func testWillShowCell_notLastCell_doNothing(){
        //given
        moviesListUseCaseMock.status = .success
        sut.viewDidLoad()
        //when
        sut.willShowCell(atIndex: 0)
        //then
        let recivedPage = moviesListUseCaseMock.getMoviesReceivedArguments?.page
        XCTAssertNotEqual(recivedPage, 2)
    }
    
    func testWillShowCell_lastCell_fetchNextPage(){
        //given
        moviesListUseCaseMock.status = .success
        sut.viewDidLoad()
        //when
        sut.willShowCell(atIndex: 2)
        //then
        let recivedPage = moviesListUseCaseMock.getMoviesReceivedArguments?.page
        XCTAssertEqual(recivedPage, 2)
    }
    
    func testWillShowCell_lastCell_startFooterActivityIndicator(){
        //given
        moviesListUseCaseMock.status = .success
        sut.viewDidLoad()
       
        //when
        var showSignal: Bool = false
        sut.showFooterActivityIndicator.first().sink { show in
            showSignal = show
        }.store(in: &cancellables)
        sut.willShowCell(atIndex: 2)
        
        //then
        XCTAssertTrue(showSignal)
    }

}

// MARK: - searchButtonDidTapped
extension MoviesListViewModelTests {
    func testSearchButtonDidTapped_textNotEmpty_filterMoviesAndReload(){
        //given
        moviesListUseCaseMock.status = .success
        sut.viewDidLoad()

        //when
        var reload = false
        sut.reloadTable.sink { show in
            reload = true
        }.store(in: &cancellables)
        sut.searchButtonDidTapped(withText: "Joker")
        
        //then
        XCTAssertEqual(sut.getNumberOfMovies(), 1)
        XCTAssertEqual(sut.getMovie(atIndex: 0), MovieStub.movie2)
        XCTAssertTrue(reload)
    }
}


// MARK: - cancelSearchButtonDidTapped
extension MoviesListViewModelTests {
    func testCancelSearchButtonDidTapped_removeAllfilterdAndReload(){
        //given
        moviesListUseCaseMock.status = .success
        sut.viewDidLoad()
        sut.searchButtonDidTapped(withText: "Joker")

        //when
        var reload = false
        sut.reloadTable.sink { show in
            reload = true
        }.store(in: &cancellables)
        sut.cancelSearchButtonDidTapped()
        //then
        XCTAssertEqual(sut.getNumberOfMovies(), 3)
        XCTAssertTrue(reload)
    }
}

// MARK: - didSelectTag
extension MoviesListViewModelTests {
    func testDidSelectTag_actionTag_filterAllActionMoviesAndReload(){
        //given
        moviesListUseCaseMock.status = .success
        sut.viewDidLoad()

        //when
        var reload = false
        sut.reloadTable.sink { show in
            reload = true
        }.store(in: &cancellables)
        sut.didSelectTag(withId: 28)
        
        //then
        XCTAssertEqual(sut.getNumberOfMovies(), 2)
        XCTAssertEqual(sut.getMovie(atIndex: 0), MovieStub.movie1)
        XCTAssertEqual(sut.getMovie(atIndex: 1), MovieStub.movie3)
        XCTAssertTrue(reload)
    }
}

// MARK: - didDeselectTag
extension MoviesListViewModelTests {
    func testDidDeselectTag_removeFilterationAndReload(){
        //given
        moviesListUseCaseMock.status = .success
        sut.viewDidLoad()
        sut.didSelectTag(withId: 28)

        //when
        var reload = false
        sut.reloadTable.sink { show in
            reload = true
        }.store(in: &cancellables)
        sut.didDeselectTag(withId: 28)
        //then
        XCTAssertEqual(sut.getNumberOfMovies(), 3)
        XCTAssertTrue(reload)
    }
}

// MARK: - Refresh
extension MoviesListViewModelTests {
    func testRefresh_startFromFirstPageAgain(){
        //given
        moviesListUseCaseMock.status = .success
        sut.viewDidLoad()
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
        moviesListUseCaseMock.status = .success
        sut.viewDidLoad()
        sut.searchButtonDidTapped(withText: "Joker")
        //when
        let numOfMovies = sut.getNumberOfMovies()
        //then
        XCTAssertEqual(numOfMovies, 1)
    }
    
    func testGetNumberOfMovies_searchModeOff_returnNormalCount(){
        //given
        moviesListUseCaseMock.status = .success
        sut.viewDidLoad()

        //when
        let numOfMovies = sut.getNumberOfMovies()
        //then
        XCTAssertEqual(numOfMovies, 3)
    }
    
    func testGetMovie_searchModeOn_returnMovieFromSearchResult(){
        //given
        moviesListUseCaseMock.status = .success
        sut.viewDidLoad()
        sut.searchButtonDidTapped(withText: "Joker")
        //when
        let movie = sut.getMovie(atIndex: 0)
        //then
        XCTAssertEqual(movie, MovieStub.movie2)
    }
}
