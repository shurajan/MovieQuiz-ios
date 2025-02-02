//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Alexander Bralnin on 21.05.2024.
//

import Foundation

struct AlertModel {
    let id: String
    let title: String
    let message: String
    let buttonText: String
    let completion: ()->Void
}
