//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Alexander Bralnin on 24.06.2024.
//

import Foundation

struct GameResult: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    private enum CodingKeys: CodingKey {
        case correct, total, date
    }
    
    // MARK: - Initializers
    init() {
        self.correct = 0
        self.total = 0
        self.date = Date()
    }
    
    init(correct: Int, total: Int) {
        self.correct = correct
        self.total = total
        self.date = Date()
    }
    
    init(from decoder: any Decoder)  throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.correct = try container.decode(Int.self, forKey: .correct)
        self.total = try container.decode(Int.self, forKey: .total)
        self.date = try container.decode(Date.self, forKey: .date)
    }
    
    // MARK: - Public Methods
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.correct, forKey: .correct)
        try container.encode(self.total, forKey: .total)
        try container.encode(self.date, forKey: .date)
    }
    
    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
