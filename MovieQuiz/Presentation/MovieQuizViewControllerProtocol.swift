//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Alexander Bralnin on 18.06.2024.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    func blockButtons()
    func unblockButtons()
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
    func showImageLoadingError(message: String)
}
