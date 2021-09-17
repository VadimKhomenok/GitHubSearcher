//
//  AlertPresentableProtocol.swift
//  GitHubSearcher
//
//  Created by Vadim Khomenok on 17.09.21.
//

import UIKit

protocol AlertPresentableProtocol where Self: UIViewController {
    func showErrorAlert(withError error: LocalizedError)
}

extension AlertPresentableProtocol {
    func showErrorAlert(withError error: LocalizedError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error occured", message: error.errorDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
