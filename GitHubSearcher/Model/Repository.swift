//
//  Repository.swift
//  GitHubSearcher
//
//  Created by Vadim Khomenok on 16.09.21.
//

import Foundation

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
