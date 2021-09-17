//
//  Errors.swift
//  GitHubSearcher
//
//  Created by Vadim Khomenok on 17.09.21.
//

import Foundation

enum SearchError: Error {
    case invalidUrl(queryString: String)
    case noDataResponse
    case jsonDecodingFailed(jsonError: Error)
    case requestFailed(error: Error)
    case noInternetConnection
}

extension SearchError: LocalizedError {
    public var errorDescription: String? {
        let errorMessageLogAlias = "Error -> "
        var errorMessage: String = "Unknown error"
        
        switch self {
        case .invalidUrl(let queryString):
            errorMessage = "Failed to create URL with queryString=\(queryString)"
        case .noDataResponse:
            errorMessage = "Response doesn't contain any data"
        case .jsonDecodingFailed(let jsonError):
            errorMessage = jsonError.localizedDescription
        case .requestFailed(let error):
            errorMessage = "Request failed with error: \(error.localizedDescription)"
        case .noInternetConnection:
            errorMessage = "No internet connection"
        }
        
        return errorMessageLogAlias + errorMessage
    }
}
