//
//  MoviesListUseCaseTests.swift
//  MoviesTests
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import XCTest
@testable import Movies

final class MoviesListUseCaseTests: XCTestCase {
    var sut: MoviesListUseCase!
    let repoMock = MoviesListRepoMock()
    
    override func setUpWithError() throws {
        sut = MoviesListUseCase(repo: repoMock)
    }
    
    func testGetMovie(){
        //when
        sut.getMovies(page: 1) {_ in}
        //then
        XCTAssertTrue(repoMock.getMoviesIsCalled)
        XCTAssertEqual(repoMock.getMoviesReceivedArguments?.page, 1)
    }

}
