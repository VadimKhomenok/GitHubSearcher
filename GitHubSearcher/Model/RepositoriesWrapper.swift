//
//  RepositoriesWrapper.swift
//  GitHubSearcher
//
//  Created by Vadim Khomenok on 17.09.21.
//

import Foundation

struct RepoWrapper: Codable {
    var incompleteResults: Bool
    var totalCount: Int
    var items: [Repository]?
    
    private enum CodingKeys : String, CodingKey {
        case incompleteResults = "incomplete_results", totalCount = "total_count", items
    }
}

// MARK: - Paging calculations

extension RepoWrapper {
    var isFinished: Bool {
        (items?.count ?? 0) == totalCount
    }
    
    var currentPage: Int {
        guard let items = items else { return 0 }
        return Int(items.count / Constants.reposPerPage) + 1
    }
    
    var nextPage: Int {
        isFinished ? currentPage : currentPage + 1
    }
}
