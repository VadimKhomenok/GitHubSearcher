//
//  UIViewController+Loading.swift
//  GitHubSearcher
//
//  Created by Vadim Khomenok on 17.09.21.
//

import UIKit

protocol LoadingStateProtocol {
    var activityIndicator: UIActivityIndicatorView! { get set }
    func loading(inProgress: Bool)
}

extension LoadingStateProtocol {
    func loading(inProgress: Bool) {
        DispatchQueue.main.async {
            activityIndicator.isHidden = !inProgress
            if inProgress {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
}
