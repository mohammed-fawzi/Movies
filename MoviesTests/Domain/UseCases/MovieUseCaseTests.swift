//
//  MovieUseCaseTests.swift
//  MoviesTests
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import XCTest
@testable import Movies

final class MovieUseCaseTests: XCTestCase {
    var sut: MovieUseCase!
    let repoMock = MovieRepoMock()
    
    override func setUpWithError() throws {
        sut = MovieUseCase(repo: repoMock)
    }
    
    func testGetMovie(){
        //when
        sut.getMovie(withId: 12345) {_ in}
        //then
        XCTAssertTrue(repoMock.getMovieIsCalled)
        XCTAssertEqual(repoMock.getMovieReceivedArguments?.id, 12345)
    }

}
