//
//  UIViewController+HideKeyboard.swift
//  GitHubSearcher
//
//  Created by Vadim Khomenok on 17.09.21.
//

import UIKit

protocol TapOutsideHideKeyboardProtocol: AnyObject {
    var hideKeyboardTapGestureRecognizer: UITapGestureRecognizer? { get set }
    func setupTapGesture()
}

extension TapOutsideHideKeyboardProtocol where Self: UIViewController {
    func setupTapGesture() {
        guard self.hideKeyboardTapGestureRecognizer == nil else { return }
        
        hideKeyboardTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        view.addGestureRecognizer(hideKeyboardTapGestureRecognizer!)
        hideKeyboardTapGestureRecognizer!.cancelsTouchesInView = false
    }
}

fileprivate extension UIViewController {
    @objc func hideKeyboard(_ sender: UITapGestureRecognizer?) {
        view.endEditing(true)
    }
}
