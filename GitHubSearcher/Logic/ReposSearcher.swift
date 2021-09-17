//
//  ReposSearcher.swift
//  GitHubSearcher
//
//  Created by Vadim Khomenok on 17.09.21.
//

import Foundation

protocol ReposSearcherDelegate: AnyObject {
    func repositoriesLoaded(repositoriesList: [Repository], hasMore: Bool)
    func moreRepositoriesLoaded(newRepositoriesList: [Repository], hasMore: Bool)
}

protocol ReposSearcherProtocol {
    func searchRepositories(withKeyword keyword: String)
    func fetchMore(withKeyword keyword: String)
}

class ReposSearcher: ReposSearcherProtocol {
    private let gitHubAPI = GitHubAPI()
    private var cachedSearchResult: RepoWrapper?
    private var fetchInProgress: Bool = false
    
    weak var delegate: ReposSearcherDelegate?
    
    func searchRepositories(withKeyword keyword: String) {
        fetchInProgress = false
        gitHubAPI.searchOpenSourceRepos(keyword: keyword) { [weak self] searchResult in
            self?.cachedSearchResult = searchResult
            self?.delegate?.repositoriesLoaded(repositoriesList: searchResult.items ?? [], hasMore: !searchResult.isFinished)
        }
    }
    
    func fetchMore(withKeyword keyword: String) {
        guard !fetchInProgress else { return }
        guard let cachedSearchResult = cachedSearchResult else { return }
        guard !cachedSearchResult.isFinished else {
            delegate?.moreRepositoriesLoaded(newRepositoriesList: [], hasMore: false)
            return
        }
        
        print("--- fetch performed")
        fetchInProgress = true
        gitHubAPI.searchOpenSourceRepos(keyword: keyword, page: cachedSearchResult.nextPage, completion: { [weak self] searchResult in
            let newItems = searchResult.items ?? []
            self?.cachedSearchResult?.items?.append(contentsOf: newItems)
            self?.delegate?.moreRepositoriesLoaded(newRepositoriesList: newItems, hasMore: !(self?.cachedSearchResult?.isFinished ?? true))
            self?.fetchInProgress = false
        })
    }
}


