//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Alexander Bralnin on 17.06.2024.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    // MARK: - Instance Variables
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol?
    private var correctAnswers = 0
    
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var statisticService: StatisticServiceProtocol = StatisticServiceImplementation()
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        self.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        self.viewController?.blockButtons()
        loadData()
    }
    
    // MARK: - QuestionFactoryDelegate Implementation
    func didReceiveNextQuestion(question: QuizQuestion?) {
        viewController?.hideLoadingIndicator()
        guard let question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didFailToLoadImage(with error: Error){
        viewController?.hideLoadingIndicator()
        viewController?.showImageLoadingError(message: error.localizedDescription)
    }
    
    func didLoadDataFromServer() {
        viewController?.unblockButtons()
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.hideLoadingIndicator()
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: - Public Methods
    func loadData(){
        viewController?.showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    func loadQuestionData(){
        viewController?.showLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func restartGame(){
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex+1)/\(questionsAmount)")
        
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    // MARK: - Private Methods
    private func isLastQuestion()->Bool {
        return currentQuestionIndex == questionsAmount - 1
    }
    
    private func showNextQuestionOrResults() {
        if !self.isLastQuestion() {
            currentQuestionIndex += 1
            self.loadQuestionData()
            return
        }
        
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let text = """
            Ваш результат: \(correctAnswers)/\(questionsAmount)
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд: \(statisticService.bestGame.correct)/\(questionsAmount) (\(statisticService.bestGame.date.dateTimeString))
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
            """
        
        let viewModel = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: text,
            buttonText: "Сыграть ещё раз")
        viewController?.show(quiz: viewModel)
        
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        viewController?.blockButtons()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.viewController?.unblockButtons()
            self.showNextQuestionOrResults()
        }
    }
    
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == isYes)
    }
    
    
}
