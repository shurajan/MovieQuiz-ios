//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Alexander Bralnin on 13.06.2024.
//

import Foundation
import XCTest
@testable import MovieQuiz

final class ArrayTests: XCTestCase {
    func testGetValueInRange() throws { // тест на успешное взятие элемента по индексу
        // Given
        let array = [1, 2, 3, 4, 5]
        
        // When
        let value = array[safe: 2]
        
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 3)
    }
    
    func testGetValueOutOfRange() throws { // тест на взятие элемента по неправильному индексу
        // Given
        let array = [1, 2, 3, 4, 5]
        
        // When
        let value = array[safe: 20]
        
        // Then
        XCTAssertNil(value)
    }
}
