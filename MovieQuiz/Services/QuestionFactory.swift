//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Alexander Bralnin on 20.05.2024.
//

import Foundation


final class QuestionFactory : QuestionFactoryProtocol{
    
    // MARK: - Private Properties
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    
    // MARK: - Questions
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    // MARK: - Public Methods
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didFailToLoadImage(with: error)
                }
            }
            
            let rating = Float(movie.rating) ?? 0
            let (text, correctAnswer) = generateRandomQuestion(from: rating)
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    // MARK: - Private Methods
    private func generateRandomQuestion(from rating:Float) -> (String, Bool) {
        let integerRating = Int(rating)
        let isBigger = Bool.random()
        let testRating = Int.random(in: integerRating-1..<10)
        
        if isBigger {
            let text = "Рейтинг этого фильма больше чем \(testRating)?"
            let correctAnswer = rating > Float(testRating)
            return (text, correctAnswer)
        } else {
            let text = "Рейтинг этого фильма меньше чем \(testRating)?"
            let correctAnswer = rating < Float(testRating)
            return (text, correctAnswer)
        }
    }
}
