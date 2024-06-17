//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Alexander Bralnin on 17.06.2024.
//

import UIKit

final class MovieQuizPresenter {
    // MARK: - Instance Variables
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    // MARK: - Public Methods
    
    func isLastQuestion()->Bool {
        return currentQuestionIndex == questionsAmount-1
    }
    
    func resetQuestionIndex(){
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion(){
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        
    }
}
