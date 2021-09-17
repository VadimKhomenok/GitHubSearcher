//
//  Owner.swift
//  GitHubSearcher
//
//  Created by Vadim Khomenok on 17.09.21.
//

import Foundation

struct Owner: Codable {
    var login: String?
    var avatarUrl: String?
    
    private enum CodingKeys : String, CodingKey {
        case login, avatarUrl = "avatar_url"
    }
}
