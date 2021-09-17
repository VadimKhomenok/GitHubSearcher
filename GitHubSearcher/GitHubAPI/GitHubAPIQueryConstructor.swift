//
//  GitHubAPIQueryConstructor.swift
//  GitHubSearcher
//
//  Created by Vadim Khomenok on 17.09.21.
//

import Foundation

enum QueryParameter {
    case page(value: Int?)
    
    var fullString: String {
        "\(identifier):\(value)"
    }
    
    private var identifier: String {
        switch self {
        case .page: return "page"
        }
    }
    
    private var value: String {
        switch self {
        case .page(let value): return String(value ?? Constants.pageByDefault)
        }
    }
}

enum QueryQualifiers {
    case license(searchLicenses: [String])
    
    var fullString: String {
        switch self {
        case .license:
            return value
        }
    }
    
    private var identifier: String {
        switch self {
        case .license: return "license"
        }
    }
    
    private var value: String {
        var result = ""
        switch self {
        case .license(let licensesArray):
            result = licensesArray
                .map { licenseName in
                    return identifier + ":" + licenseName
                }
                .joined(separator: "+")
        }
        return result
    }
}

struct QueryConstructor {
    static func queryString(forKeyword keyword: String, qualifiers: [QueryQualifiers]? = nil, withParameters parameters: [QueryParameter]? = nil) -> String {
        let fixedString = keyword.replaceWhitespacesInQuery()
        var queryString = "?q=\(fixedString)"
        
        if let qualifiers = qualifiers {
            for qualifier in qualifiers {
                queryString += "+\(qualifier.fullString)"
            }
        }
        
        if let parameters = parameters {
            for parameter in parameters {
                queryString += "&\(parameter.fullString)"
            }
        }
        
        return queryString
    }
}
