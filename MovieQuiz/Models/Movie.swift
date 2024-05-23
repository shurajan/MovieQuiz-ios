//
//  Movie.swift
//  MovieQuiz
//
//  Created by Alexander Bralnin on 23.05.2024.
//

import Foundation

enum ParseError: Error {
    case rankFailure
    case yearFailure
    case imDbRatingFailure
    case imDbRatingCountFailure
}

struct Actor: Codable {
    let id: String
    let image: String
    let name: String
    let asCharacter: String
}

struct Movie: Codable {
    let id: String
    let rank: Int
    let title: String
    let fullTitle: String
    let year: Int
    let image: String
    let crew: String
    let imDbRating: Float
    let imDbRatingCount: Int

    
    enum CodingKeys: CodingKey {
        case id, rank, title, fullTitle, year, image, crew, imDbRating, imDbRatingCount
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        
        let rank = try container.decode(String.self, forKey: .rank)
        guard let rankValue = Int(rank) else {
            throw ParseError.rankFailure
        }
        self.rank = rankValue
        
        title = try container.decode(String.self, forKey: .title)
        fullTitle = try container.decode(String.self, forKey: .fullTitle)
        
        let year = try container.decode(String.self, forKey: .year)
        guard let yearValue = Int(year) else {
            throw ParseError.yearFailure
        }
        self.year = yearValue
        
        image = try container.decode(String.self, forKey: .image)
        crew = try container.decode(String.self, forKey: .crew)
        
        let imDbRating = try container.decode(String.self, forKey: .imDbRating)
        guard let imDbRatingValue = Float(imDbRating) else {
            throw ParseError.imDbRatingFailure
        }
        self.imDbRating = imDbRatingValue
        
        let imDbRatingCount = try container.decode(String.self, forKey: .imDbRatingCount)
        guard let imDbRatingCountValue = Int(imDbRatingCount) else {
            throw ParseError.imDbRatingCountFailure
        }
        self.imDbRatingCount = imDbRatingCountValue
        
    }
}

struct Top: Decodable {
    let items: [Movie]
}
