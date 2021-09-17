//
//  GitHubAPI.swift
//  GitHubSearcher
//
//  Created by Vadim Khomenok on 16.09.21.
//

import Foundation

fileprivate enum Endpoint: String {
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
        cancelTasks()
        
        var queryString = "?q=\(keyword)"
        if let page = page {
            queryString = queryString + "&page=\(page)"
        }
        
        guard let url = Endpoint.searchRepo.url(withQuery: queryString) else { return }
        performRequest(withUrl: url, httpMethod: .get, parameters: nil) { (items: RepoWrapper) in
            completion(items)
        }
    }
    
    /// Generic function to execute a request with json data response and to decode this data into specific object
    private func performRequest<T: Decodable>(withUrl url: URL, httpMethod: HTTPMethod, parameters: [String : Any]? = nil, completion: @escaping (T) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.addApiVersionHeader()
        
//        if let parameters = parameters {
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: parameters)
//                request.httpBody = jsonData
//                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//                request.setValue("application/json", forHTTPHeaderField: "Accept")
//            } catch {
//                return .failure(.invalidJsonFormatRequest)
//            }
//        }

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
