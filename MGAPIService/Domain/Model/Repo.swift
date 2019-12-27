//
//  Repo.swift
//  MGAPIService
//
//  Created by Tuan Truong on 4/5/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import ObjectMapper
import Then

struct Repo {
    var id = 0
    var name: String
    var fullname: String
    var urlString: String
    var starCount: Int
    var folkCount: Int
    var avatarURLString: String
    var owner: String
}

extension Repo: Equatable {

}

extension Repo {
    init() {
        self.init(
            id: 0,
            name: "",
            fullname: "",
            urlString: "",
            starCount: 0,
            folkCount: 0,
            avatarURLString: "",
            owner: ""
        )
    }
}

extension Repo: Then { }

extension Repo: Mappable {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        fullname <- map["full_name"]
        urlString <- map["html_url"]
        starCount <- map["stargazers_count"]
        folkCount <- map["forks"]
        avatarURLString <- map["owner.avatar_url"]
        owner <- map["owner.login"]
    }
}
