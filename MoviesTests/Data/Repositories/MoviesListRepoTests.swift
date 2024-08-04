//
//  MoviesListRepoTests.swift
//  MoviesTests
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import XCTest
@testable import Movies

final class MoviesListRepoTests: XCTestCase {
    
    var sut: MoviesListRepo!
    var networkStoreMock = NetworkStoreMock()
    var cacheStoreMock = APICacheStoreMock()
    override func setUpWithError() throws {
        sut = MoviesListRepo(networkStore: networkStoreMock, cacheStore: cacheStoreMock , type: .nowPlaying)
        networkStoreMock.data = MoviesListDTOStub.rawData
    }
}

// MARK: - GetMovies
extension MoviesListRepoTests {
    func testGetMovies_nowPlayingType_getNowPlayingMoviesFormNetwork(){
        //given
        sut = MoviesListRepo(networkStore: networkStoreMock, cacheStore: cacheStoreMock , type: .nowPlaying)
        //when
        sut.getMovies(page: 1) {_ in }
        //then
        let recivedEndpoint = networkStoreMock.sendRequestReceivedArguments?.endpoint as? MoviesListEndPoint
        let expectedEndPoint = MoviesListEndPoint.nowPlaying(page: 1)
        XCTAssertTrue(networkStoreMock.sendRequestIsCalled) 
        XCTAssertEqual(recivedEndpoint , expectedEndPoint)
    }
    
    func testGetMovies_PopularType_getPopularMoviesFormNetwork(){
        //given
        sut = MoviesListRepo(networkStore: networkStoreMock, cacheStore: cacheStoreMock , type: .trending)
        //when
        sut.getMovies(page: 1) {_ in }
        //then
        let recivedEndpoint = networkStoreMock.sendRequestReceivedArguments?.endpoint as? MoviesListEndPoint
        let expectedEndPoint = MoviesListEndPoint.trending(page: 1)
        XCTAssertTrue(networkStoreMock.sendRequestIsCalled)
        XCTAssertEqual(recivedEndpoint , expectedEndPoint)
    }
    
    func testGetMovies_upcomingType_getUpcomingMoviesFormNetwork(){
        //given
        sut = MoviesListRepo(networkStore: networkStoreMock, cacheStore: cacheStoreMock , type: .upcoming)
        //when
        sut.getMovies(page: 1) {_ in }
        //then
        let recivedEndpoint = networkStoreMock.sendRequestReceivedArguments?.endpoint as? MoviesListEndPoint
        let expectedEndPoint = MoviesListEndPoint.upcoming(page: 1)
        XCTAssertTrue(networkStoreMock.sendRequestIsCalled)
        XCTAssertEqual(recivedEndpoint , expectedEndPoint)
    }
    
    func testGetMovies_networkSuccess_saveFetchedDataToCache(){
        //given
        networkStoreMock.status = .success
        //when
        sut.getMovies(page: 1) {_ in}
        //then
        let receivedData = cacheStoreMock.insertResponseReceivedArguments?.data
        let receivedEndPoint = cacheStoreMock.insertResponseReceivedArguments?.endPoint as? MoviesListEndPoint
        let expectedData = MoviesListDTOStub.rawData
        let expectedEndPoint = MoviesListEndPoint.nowPlaying(page: 1)
        
        XCTAssertTrue(cacheStoreMock.insertResponseIsCalled)
        XCTAssertEqual(receivedData , expectedData)
        XCTAssertEqual(receivedEndPoint , expectedEndPoint)
    }
    
    func testGetMovies_networkSuccess_mapToDomainModel(){
        //given
        networkStoreMock.status = .success
        //when
        var receivedMoviesList = MoviesList(page: 0, movies: [], totalPages: 0, totalResults: 0)
        sut.getMovies(page: 1) { result in
            switch result {
            case .success(let movieList):
                receivedMoviesList = movieList
            case .failure(_):
                    XCTFail()
            }
        }
        //then
        XCTAssertEqual(receivedMoviesList.page, 1)
        XCTAssertEqual(receivedMoviesList.movies.count, 3)
        XCTAssertEqual(receivedMoviesList.totalPages, 3)
        XCTAssertEqual(receivedMoviesList.totalResults, 15)
    }
    
    func testGetMovies_networkFailureCacheExists_getFromCache(){
        //given
        networkStoreMock.status = .failure(error: .noInternetConnection)
        cacheStoreMock.status = .success
        //when
        sut.getMovies(page: 1) {_ in}
    
        //then
        let receivedEndPoint = cacheStoreMock.getResponseReceivedEndpoint as? MoviesListEndPoint
        let expectedEndPoint = MoviesListEndPoint.nowPlaying(page: 1)
        
        XCTAssertTrue(cacheStoreMock.getResponseIsCalled)
        XCTAssertEqual(receivedEndPoint , expectedEndPoint)
        
    }
    
    func testGetMovies_networkFailureNoCache_sendFailure(){
        //given
        networkStoreMock.status = .failure(error: .noInternetConnection)
        cacheStoreMock.status = .failure(error: .noCacheFound)
        //when
        var error: MoviesError = .unknownError
        sut.getMovies(page: 1) { result in
            switch result {
            case .success(_):
                    XCTFail()
            case .failure(let err):
                error = err
            }
        }
        //then
        XCTAssertEqual(error, .noCacheFound)
    }
}

