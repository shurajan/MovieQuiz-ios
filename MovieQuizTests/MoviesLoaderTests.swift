//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Alexander Bralnin on 13.06.2024.
//
import Foundation
import XCTest
@testable import MovieQuiz


final class MoviesLoaderTests: XCTestCase {
    func testSuccessLoading () throws {
        // Given
        let stubNetworkService:NetworkRouting = StubNetworkService(emulateError: false)
        let loader = MoviesLoader(networkService: stubNetworkService)
        
        // When
        
        
        // Then
        let expectation = expectation(description: "Movies loading expectation")
        
        loader.loadMovies {result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
            
        }
        waitForExpectations(timeout: 1)
    }
    
    func testFailureLoading () throws {
        // Given
        // Given
        let stubNetworkService:NetworkRouting = StubNetworkService(emulateError: true)
        let loader = MoviesLoader(networkService: stubNetworkService)
        
        // When
        
        
        // Then
        // Then
        let expectation = expectation(description: "Movies loading expectation")
        
        loader.loadMovies {result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
            
        }
        waitForExpectations(timeout: 1)
        
    }
}
