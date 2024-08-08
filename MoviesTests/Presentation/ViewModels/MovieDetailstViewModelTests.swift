//
//  MovieDetailstViewModelTests.swift
//  MoviesTests
//
//  Created by Mohamed Fawzy on 04/08/2024.
//

import XCTest
@testable import Movies
@testable import PresentationLayer
@testable import Common

final class MovieDetailstViewModelTests: XCTestCase {
    var sut: MovieDetailsViewModel!
    var useCaseMock = MovieUseCaseMock()
    let dispatchQueueMock = DispatchQueueMock()
    let movie = MovieStub.movie1
    override func setUpWithError() throws {
        useCaseMock.status = .success
        sut = MovieDetailsViewModel(useCase: useCaseMock,
                                    movie: movie,
                                    dispatchQueue: dispatchQueueMock)
    }
}


// MARK: - Init
extension MovieDetailstViewModelTests{
    func testInit_setInfoCardData(){
       
        XCTAssertEqual(sut.title, movie.title)
        XCTAssertEqual(sut.overview, movie.overview)
        XCTAssertEqual(sut.poster, movie.posterUrl)
    }
}
// MARK: - init
extension MovieDetailstViewModelTests{
    func testInit_fetchMovieDetails(){
        //then
        XCTAssertTrue(useCaseMock.getMovieIsCalled)
        XCTAssertEqual(useCaseMock.getMovieReceivedArguments?.id, movie.id)
    }
    
    func testInit_fetchDetailsSuccess_setGenres(){
        XCTAssertEqual(sut.genres, "adventure, scifi, action")
    }
    
    func testInit_fetchDetailsSuccess_setDetailsTags(){
        //then
        XCTAssertEqual(sut.tags.count, 7)
        // spoken language tag
        XCTAssertEqual(sut.tags[0].name,"EN,AR")
        XCTAssertEqual(sut.tags[0].icon,nil)
        XCTAssertEqual(sut.tags[0].iconColor,nil)
        //score tag
        XCTAssertEqual(sut.tags[1].name,"9.1")
        XCTAssertEqual(sut.tags[1].icon,"star.fill")
        XCTAssertEqual(sut.tags[1].iconColor,"AccessoryColor")
        //score release date
        XCTAssertEqual(sut.tags[2].name,"2024-8-4")
        XCTAssertEqual(sut.tags[2].icon,nil)
        XCTAssertEqual(sut.tags[2].iconColor,nil)
        //runtime
        XCTAssertEqual(sut.tags[3].name,"120 Min")
        XCTAssertEqual(sut.tags[3].icon,"clock.arrow.circlepath")
        XCTAssertEqual(sut.tags[3].iconColor,"TextSecondryColor")
        //status
        XCTAssertEqual(sut.tags[4].name,"released")
        XCTAssertEqual(sut.tags[4].icon,nil)
        XCTAssertEqual(sut.tags[4].iconColor,nil)
        //budget
        XCTAssertEqual(sut.tags[5].name,"Budget: 1.0M")
        XCTAssertEqual(sut.tags[5].icon,nil)
        XCTAssertEqual(sut.tags[5].iconColor,nil)
        //revenue
        XCTAssertEqual(sut.tags[6].name,"Revenue: 2.0M")
        XCTAssertEqual(sut.tags[6].icon,nil)
        XCTAssertEqual(sut.tags[6].iconColor,nil)
    }
    
    func testViewDidload_fetchDetailsFailure_showErrorMessage(){
        //given
        useCaseMock.status = .failure(error: .noInternetConnection)

        //when
        sut = MovieDetailsViewModel(useCase: useCaseMock,
                                           movie: movie,
                                           dispatchQueue: dispatchQueueMock)
        
        //then
        XCTAssertEqual(sut.errorMessage, MoviesError.noInternetConnection.customMessage)
    }
}
