//
//  OpenSafariProtocol.swift
//  GitHubSearcher
//
//  Created by Vadim Khomenok on 17.09.21.
//

import UIKit

protocol OpenSafariProtocol {
    func open(url: String)
}

extension OpenSafariProtocol {
    func open(url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
}
