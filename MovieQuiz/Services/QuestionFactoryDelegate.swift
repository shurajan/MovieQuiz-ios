//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Alexander Bralnin on 21.05.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {               
    func didReceiveNextQuestion(question: QuizQuestion?)
}
