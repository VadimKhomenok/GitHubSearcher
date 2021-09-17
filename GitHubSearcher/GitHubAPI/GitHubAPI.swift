//
//  GitHubAPI.swift
//  GitHubSearcher
//
//  Created by Vadim Khomenok on 16.09.21.
//

import Foundation

fileprivate enum RequestAddress: String {
    case searchRepo = "/search/repositories"
    
    private var baseURL: String {
        return "https://api.github.com"
    }
    
    var url: URL? {
        return URL(string: baseURL.appending(rawValue))
    }
    
    func url(withQuery query: String) -> URL? {
        return URL(string: baseURL.appending(rawValue).appending(query))
    }
}

struct GitHubAPI {
    /**
     Allows to search for open source repositories
     
     - Parameters:
        - keyword: String value with keyword to search
        - page: Int value with page number if it is necessary to get search results for specific page. May be omitted, in this case API will return page 1 by default
        - completion: Closure with result of search. If success - will return RepoWrapper object which contains first N repos and total number of repos. In case of failure will return an error
     */
    func searchOpenSourceRepos(keyword: String, page: Int? = nil, completion: @escaping (Result<RepoWrapper, SearchError>) -> Void) {
        let qualifiers: [QueryQualifiers] = [.license(searchLicenses: Constants.openSourceLicenses)]
        var parameters: [QueryParameter]?
        if let page = page {
            parameters = [.page(value: page)]
        }
        
        let queryString = QueryConstructor.queryString(forKeyword: keyword, qualifiers: qualifiers, withParameters: parameters)
        guard let url = RequestAddress.searchRepo.url(withQuery: queryString) else {
            completion(.failure(SearchError.invalidUrl(queryString: queryString)))
            return
        }
        
        cancelTasks()
        performRequest(withUrl: url, httpMethod: .get) { (result: Result<RepoWrapper, SearchError>) in
            completion(result)
        }
    }
    
    /// Generic function to execute a request with json data response and to decode this data into specific object
    private func performRequest<T: Decodable>(withUrl url: URL, httpMethod: HTTPMethod, completion: @escaping (Result<T, SearchError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.addApiVersionHeader()

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil /*let decodedObject = try? JSONDecoder().decode(T.self, from: data)*/ else {
                var searchError = SearchError.noDataResponse
                if let error = error {
                    searchError = SearchError.requestFailed(error: error)
                }
                
                completion(.failure(searchError))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch let jsonError as NSError {
                completion(.failure(SearchError.jsonDecodingFailed(jsonError: jsonError)))
            }
        }
        
        task.resume()
    }
    
    /// Cancels previous requests before the execution of new one
    private func cancelTasks() {
        URLSession.shared.getAllTasks(completionHandler: { tasks in
            tasks.forEach { task in
                task.cancel()
            }
        })
    }
}
