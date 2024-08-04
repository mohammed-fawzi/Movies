//
//  MovieDetailstViewModelTests.swift
//  MoviesTests
//
//  Created by Mohamed Fawzy on 04/08/2024.
//

import XCTest
@testable import Movies

final class MovieDetailstViewModelTests: XCTestCase {
    var sut: MovieDetailsViewModel!
    var useCaseMock = MovieUseCaseMock()
    let movie = MovieStub.movie1
    var coordinatorMock = CoordinatorMock()
    override func setUpWithError() throws {
        sut = MovieDetailsViewModel(useCase: useCaseMock,
                                    movie: movie,
                                    coordinator: coordinatorMock)
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
// MARK: - viewDidLoad
extension MovieDetailstViewModelTests{
    func testViewDidload_fetchMovieDetails(){
        //when
        sut.viewDidLoad()
        //then
        XCTAssertTrue(useCaseMock.getMovieIsCalled)
        XCTAssertEqual(useCaseMock.getMovieReceivedArguments?.id, movie.id)
    }
    
    func testViewDidload_fetchDetailsSuccess_setGenres(){
        //given
        useCaseMock.status = .success
        //when
        sut.viewDidLoad()
        //then
        XCTAssertEqual(sut.genres, "adventure, scifi, action")
    }
    
    func testViewDidload_fetchDetailsSuccess_setDetailsTags(){
        //given
        useCaseMock.status = .success
        //when
        sut.viewDidLoad()
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
        sut.viewDidLoad()
        
        //then
        XCTAssertEqual(sut.errorMessage, MoviesError.noInternetConnection.customMessage)
    }
}

// MARK: - homePageButtonDidTapped
extension MovieDetailstViewModelTests {
    func testHomePageButtonDidTapped_redirectToBrowser(){
        //given
        useCaseMock.status = .success
        //when
        sut.viewDidLoad()
        sut.homePageButtonDidTapped()
        //then
        XCTAssertTrue(coordinatorMock.openExternalURLIsCalled)
        XCTAssertEqual(coordinatorMock.openExternalURLReceivedUrl, "http://Test.com")
    }
}
