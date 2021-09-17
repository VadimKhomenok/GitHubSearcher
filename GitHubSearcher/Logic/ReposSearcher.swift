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
    func errorHappened(error: SearchError)
}

protocol ReposSearcherProtocol {
    func searchRepositories(withKeyword keyword: String)
    func fetchMore(withKeyword keyword: String)
}

fileprivate enum ReposSearcherProcessType {
    case search
    case fetch
}

class ReposSearcher: ReposSearcherProtocol {
    private let gitHubAPI = GitHubAPI()
    private var cachedSearchResult: RepoWrapper?
    private var fetchInProgress: Bool = false
    
    weak var delegate: ReposSearcherDelegate?
    
    func searchRepositories(withKeyword keyword: String) {
        fetchInProgress = false
        gitHubAPI.searchOpenSourceRepos(keyword: keyword) { [weak self] searchResult in
            self?.handleApiResult(result: searchResult, processType: .search)
//            switch searchResult {
//            case .success(let repoWrapper):
//                self?.cachedSearchResult = repoWrapper
//                self?.delegate?.repositoriesLoaded(repositoriesList: repoWrapper.items ?? [], hasMore: !repoWrapper.isFinished)
//            case .failure(let error):
//                self?.delegate?.errorHappened(error: error)
//            }
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
            self?.fetchInProgress = false
            self?.handleApiResult(result: searchResult, processType: .fetch)
//            switch searchResult {
//            case .success(let repoWrapper):
//                let newItems = repoWrapper.items ?? []
//                self?.cachedSearchResult?.items?.append(contentsOf: newItems)
//                self?.delegate?.moreRepositoriesLoaded(newRepositoriesList: newItems, hasMore: !(self?.cachedSearchResult?.isFinished ?? true))
//            case .failure(let error):
//                self?.delegate?.errorHappened(error: error)
//            }
        })
    }
    
    private func handleApiResult(result: Result<RepoWrapper, SearchError>, processType: ReposSearcherProcessType) {
        switch result {
        case .success(let repoWrapper):
            switch processType {
            case .search:
                self.cachedSearchResult = repoWrapper
                self.delegate?.repositoriesLoaded(repositoriesList: repoWrapper.items ?? [], hasMore: !repoWrapper.isFinished)
            case .fetch:
                let newItems = repoWrapper.items ?? []
                self.cachedSearchResult?.items?.append(contentsOf: newItems)
                self.delegate?.moreRepositoriesLoaded(newRepositoriesList: newItems, hasMore: !(self.cachedSearchResult?.isFinished ?? true))
            }
        case .failure(let error):
            self.delegate?.errorHappened(error: error)
        }
    }
}


