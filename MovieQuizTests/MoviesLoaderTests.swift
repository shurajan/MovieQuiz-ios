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
        let stubNetworkService:NetworkRouting = StubNetworkService(errorType: TestErrorType.none)
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
        let stubNetworkService:NetworkRouting = StubNetworkService(errorType: TestErrorType.getTestError)
        let loader = MoviesLoader(networkService: stubNetworkService)
        
        // When
        
        
        // Then
        let expectation = expectation(description: "Movies loading TestError expectation")
        
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
    
    func testFailureLoadingWithErrorMessage () throws {
        // Given
        let stubNetworkService:NetworkRouting = StubNetworkService(errorType: TestErrorType.getErrorMessage)
        let loader = MoviesLoader(networkService: stubNetworkService)
        
        // When
        
        
        // Then
        let expectation = expectation(description: "Movies loading with errorMessage expectation")
        
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
