//
//  MovieRepoTests.swift
//  MoviesTests
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import XCTest
@testable import Movies

final class MovieRepoTests: XCTestCase {
    
    var sut: MovieRepo!
    var networkStoreMock = NetworkStoreMock()
    var cacheStoreMock = APICacheStoreMock()
    override func setUpWithError() throws {
        sut = MovieRepo(networkStore: networkStoreMock, cacheStore: cacheStoreMock)
        networkStoreMock.data = MovieDetailsDTOStub.rawData
    }
}

// MARK: - GetMovies
extension MovieRepoTests {
    func testGetMovie_getDetailsFormNetwork(){
        //when
        sut.getMovie(withId: 1) {_ in }
        //then
        let recivedEndpoint = networkStoreMock.sendRequestReceivedArguments?.endpoint as? MovieEndPoint
        let expectedEndPoint = MovieEndPoint.details(movieID: 1)
        XCTAssertTrue(networkStoreMock.sendRequestIsCalled)
        XCTAssertEqual(recivedEndpoint , expectedEndPoint)
    }

    
    func testGetMovie_networkSuccess_saveFetchedDataToCache(){
        //given
        networkStoreMock.status = .success
        //when
        sut.getMovie(withId: 12345) {_ in}
        //then
        let receivedData = cacheStoreMock.insertResponseReceivedArguments?.data
        let receivedEndPoint = cacheStoreMock.insertResponseReceivedArguments?.endPoint as? MovieEndPoint
        let expectedData = MovieDetailsDTOStub.rawData
        let expectedEndPoint = MovieEndPoint.details(movieID: 12345)
        
        XCTAssertTrue(cacheStoreMock.insertResponseIsCalled)
        XCTAssertEqual(receivedData , expectedData)
        XCTAssertEqual(receivedEndPoint , expectedEndPoint)
    }
   
    func testGetMovie_networkSuccess_mapToDomainModel(){
        //given
        networkStoreMock.status = .success
        //when
        var receivedMovieDetails: MovieDetails?
        sut.getMovie(withId: 1) { result in
            switch result {
            case .success(let details):
                receivedMovieDetails = details
            case .failure(_):
                    XCTFail()
            }
        }
        //then
        XCTAssertEqual(receivedMovieDetails?.genres?.count, 4)
        XCTAssertEqual(receivedMovieDetails?.runtime, 97)

    }
   
    func testGetMovie_networkFailureCacheExists_getFromCache(){
        //given
        networkStoreMock.status = .failure(error: .noInternetConnection)
        cacheStoreMock.status = .success
        //when
        sut.getMovie(withId: 12345) {_ in}
    
        //then
        let receivedEndPoint = cacheStoreMock.getResponseReceivedEndpoint as? MovieEndPoint
        let expectedEndPoint = MovieEndPoint.details(movieID: 12345)
        
        XCTAssertTrue(cacheStoreMock.getResponseIsCalled)
        XCTAssertEqual(receivedEndPoint , expectedEndPoint)
        
    }
    
    func testGetMovie_networkFailureNoCache_sendFailure(){
        //given
        networkStoreMock.status = .failure(error: .noInternetConnection)
        cacheStoreMock.status = .failure(error: .noCacheFound)
        //when
        var error: MoviesError = .unknownError
        sut.getMovie(withId: 1) { result in
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

