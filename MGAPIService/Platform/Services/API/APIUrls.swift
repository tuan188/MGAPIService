//
//  APIUrls.swift
//  MGAPIService
//
//  Created by Tuan Truong on 4/5/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

extension API {
    enum Urls {
        static let getRepoList = "https://api.github.com/search/repositories"
        static let getEventList = "https://api.github.com/repos/%@/%@/events"
    }
}
