//
//  MovieQuizViewControllerMock.swift
//  MovieQuizTests
//
//  Created by Alexander Bralnin on 24.06.2024.
//
@testable import MovieQuiz
import Foundation

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz step: QuizStepViewModel){
        
    }
    func show(quiz result: QuizResultsViewModel){
        
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool){
        
    }
    func blockButtons(){
        
    }
    func unblockButtons(){
        
    }
    func showLoadingIndicator(){
        
    }
    func hideLoadingIndicator(){
        
    }
    
    func showNetworkError(message: String){
        
    }
    func showImageLoadingError(message: String){
        
    }
}
