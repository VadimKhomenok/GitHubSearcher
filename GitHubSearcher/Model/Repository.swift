//
//  Repo.swift
//  GitHubSearcher
//
//  Created by Vadim Khomenok on 16.09.21.
//

import Foundation

struct RepoWrapper: Codable {
    var incompleteResults: Bool
    var items: [Repository]?
    
    private enum CodingKeys : String, CodingKey {
        case incompleteResults = "incomplete_results", items
    }
}

struct License: Codable {
    var key: String?
    var name: String?
    var url: String?
}

struct Owner: Codable {
    var login: String?
    var avatarUrl: String?
    
    private enum CodingKeys : String, CodingKey {
        case login, avatarUrl = "avatar_url"
    }
}

struct Repository: Codable {
    var id: Int
    var name: String?
    var description: String?
    var url: String?

    var creationDate: String?
    var updatedDate: String?

    var language: String?
    var license: License?
    var owner: Owner?
    
    private enum CodingKeys : String, CodingKey {
        case id, name, description, url = "html_url", creationDate = "created_at", updatedDate = "updated_at", language, license, owner
    }
}
