//
//  GitHubAPIRequestsExtension.swift
//  GitHubSearcher
//
//  Created by Vadim Khomenok on 17.09.21.
//

import Foundation

let apiVersionHeaderValue = "application/vnd.github.v3+json"

extension URLRequest {
    mutating func addApiVersionHeader() {
        setValue(apiVersionHeaderValue, forHTTPHeaderField: "Accept")
    }
}
