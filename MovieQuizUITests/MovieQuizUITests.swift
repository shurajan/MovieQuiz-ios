//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Alexander Bralnin on 13.06.2024.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!
    let initialLoadDelay: UInt32 = 3
    let buttonTapDelay: UInt32 = 2
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()

        continueAfterFailure = false
    }
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testYesButton() throws {
        sleep(initialLoadDelay)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        sleep(buttonTapDelay)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation

        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func testNoButton() throws {
        sleep(initialLoadDelay)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(buttonTapDelay)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func testIndexLabel() throws {
        sleep(initialLoadDelay)
        app.buttons["Yes"].tap()
        sleep(buttonTapDelay)
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testRoundAlert() throws {
        sleep(initialLoadDelay)
        for _ in (0..<10) {
            app.buttons["Yes"].tap()
            sleep(buttonTapDelay)
        }
        
        let indexLabelPrior = app.staticTexts["Index"]
        XCTAssertEqual(indexLabelPrior.label, "10/10")
        let alert = app.alerts["GameResult"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть ещё раз")
        
    }
    
    func testRoundAlertButtonTap() throws {
        sleep(initialLoadDelay)
        for _ in (0..<10) {
            app.buttons["No"].tap()
            sleep(buttonTapDelay)
        }
        let alert = app.alerts["GameResult"]
        XCTAssertTrue(alert.exists)
        
        alert.buttons.firstMatch.tap()
        sleep(buttonTapDelay)
        XCTAssertFalse(alert.exists)
        
        let indexLabelAfter = app.staticTexts["Index"]
        XCTAssertEqual(indexLabelAfter.label, "1/10")
    }
}
