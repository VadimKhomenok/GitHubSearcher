//
//  String+Extension.swift
//  GitHubSearcher
//
//  Created by Vadim Khomenok on 17.09.21.
//

import Foundation

extension String {
    func trimExtraWhitespacesAndNewlines() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func replaceWhitespacesInQuery() -> String {
        let newString = trimExtraWhitespacesAndNewlines()
        return newString.components(separatedBy: " ").filter { !$0.isEmpty }.joined(separator: "+")
    }
}
