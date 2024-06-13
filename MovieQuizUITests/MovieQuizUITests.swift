//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Alexander Bralnin on 13.06.2024.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizUITests: XCTestCase {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var app: XCUIApplication!
    let delay: UInt32 = 2
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        // это специальная настройка для тестов: если один тест не прошёл,
        // то следующие тесты запускаться не будут; и правда, зачем ждать?
        continueAfterFailure = false
    }
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testYesButton() throws {
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        sleep(delay)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation

        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func testNoButton() throws {
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(delay)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func testIndexLabel() throws {
        let indexLabel = app.staticTexts["Index"]
        app.buttons["Yes"].tap()
        sleep(delay)
        
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testRoundAlert() throws {
        let indexLabel = app.staticTexts["Index"]
        for _ in (0..<10) {
            app.buttons["Yes"].tap()
            sleep(2)
        }
        XCTAssertEqual(indexLabel.label, "10/10")
        let alert = app.alerts["GameResult"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть ещё раз")
    }
    
    func testRoundAlertButtonTap() throws {
       
        for _ in (0..<10) {
            app.buttons["Yes"].tap()
            sleep(delay)
        }

        let alert = app.alerts["GameResult"]
        
        XCTAssertTrue(alert.exists)
        alert.buttons.firstMatch.tap()
        sleep(delay)
        XCTAssertFalse(alert.exists)
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "1/10")

    }
}
