//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Alexander Bralnin on 21.05.2024.
//

import UIKit

final class AlertPresenter {
    // MARK: - Instance Variables
    weak var delegate: UIViewController?
    
    // MARK: - Public methods
    func showAlert(_ alertData: AlertModel){
        guard let delegate = self.delegate else {
            return
        }
        
        let alert = UIAlertController(
            title: alertData.title,
            message: alertData.message,
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = alertData.id
        
        let action = UIAlertAction(title: alertData.buttonText, style: .default) {_ in
            alertData.completion()
        }
        
        alert.addAction(action)
        
        delegate.present(alert, animated: true, completion: nil)
    }
}
