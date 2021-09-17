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
    ///
    func searchOpenSourceRepos(keyword: String, page: Int? = nil, completion: @escaping (RepoWrapper) -> Void) {
        let qualifiers: [QueryQualifiers] = [.license(searchLicenses: Constants.openSourceLicenses)]
        var parameters: [QueryParameter]?
        if let page = page {
            parameters = [.page(value: page)]
        }
        
        let queryString = QueryConstructor.queryString(forKeyword: keyword, qualifiers: qualifiers, withParameters: parameters)
        guard let url = RequestAddress.searchRepo.url(withQuery: queryString) else { return }
        
        cancelTasks()
        performRequest(withUrl: url, httpMethod: .get) { (items: RepoWrapper) in
            completion(items)
        }
    }
    
    /// Generic function to execute a request with json data response and to decode this data into specific object
    private func performRequest<T: Decodable>(withUrl url: URL, httpMethod: HTTPMethod, completion: @escaping (T) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.addApiVersionHeader()

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let json = try? JSONDecoder().decode(T.self, from: data) else { return }
            
//            do {
//                let json = try JSONDecoder().decode(T.self, from: data)
//            } catch let jsonError as NSError {
//                print(jsonError)
//            }
            
            completion(json)
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
