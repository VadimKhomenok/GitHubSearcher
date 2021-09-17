//
//  ReposFetcher.swift
//  GitHubSearcher
//
//  Created by Vadim Khomenok on 17.09.21.
//

import Foundation

protocol ReposSearcherDelegate: AnyObject {
    func repositoriesLoaded(repositoriesList: [Repository])
    func moreRepositoriesLoaded(newRepositoriesList: [Repository])
}

protocol ReposSearcherProtocol {
    func searchRepositories(withKeyword keyword: String)
    func fetchMore()
}

class ReposSearcher: ReposSearcherProtocol {
    private let gitHubAPI = GitHubAPI()
    private var cachedSearchResult: RepoWrapper?
    
    var delegate: ReposSearcherDelegate?
    
    func searchRepositories(withKeyword keyword: String) {
        gitHubAPI.searchOpenSourceRepos(keyword: keyword) { [weak self] searchResult in
            self?.cachedSearchResult = searchResult
            self?.delegate?.repositoriesLoaded(repositoriesList: searchResult.items ?? [])
        }
    }
    
    func fetchMore() {
        <#code#>
    }
    
    
}
