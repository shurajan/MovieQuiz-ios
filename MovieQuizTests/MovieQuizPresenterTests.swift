//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Alexander Bralnin on 18.06.2024.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        //Given
        let viewControllerMock = MovieQuizViewControllerMock()
        let movieQuizPresenter = MovieQuizPresenter(viewController: viewControllerMock)
        
        //When
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = movieQuizPresenter.convert(model: question)
        
        //Then
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
