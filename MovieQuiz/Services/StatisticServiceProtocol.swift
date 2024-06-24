//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Alexander Bralnin on 24.05.2024.
//

import Foundation

protocol StatisticServiceProtocol {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    
    func store(correct count: Int, total amount: Int)
}
