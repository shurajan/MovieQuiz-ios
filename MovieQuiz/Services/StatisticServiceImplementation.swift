//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Alexander Bralnin on 24.05.2024.
//

import UIKit

final class StatisticServiceImplementation {
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
    }
    
    private enum BestGameKeys: String {
        case correct
        case total
        case date
    }
    
    private var correctAnswers: Int {
        get {
            storage.integer(forKey: Keys.correct.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
}

//MARK: - StatisticsService protocol implementation
extension StatisticServiceImplementation: StatisticService {
    var totalAccuracy: Double {
        if gamesCount > 0 {
            return Double(correctAnswers * 10)/Double(gamesCount)
        }
        
        return 0
    }
    
    var gamesCount: Int {
        get {
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let decoder = JSONDecoder()
            if let savedBestGame = storage.data(forKey: Keys.bestGame.rawValue),
               let bestGame = try? decoder.decode(GameResult.self, from: savedBestGame) {
                return bestGame
            }
            
            return GameResult()
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                storage.set(encoded, forKey: Keys.bestGame.rawValue)
            }
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let latestGameResult = GameResult(correct: count, total: amount)
        if latestGameResult.isBetterThan(self.bestGame) {
            self.bestGame = latestGameResult
        }
        self.gamesCount+=1
        self.correctAnswers+=count
    }
}
