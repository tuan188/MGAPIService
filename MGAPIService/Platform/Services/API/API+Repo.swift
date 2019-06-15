//
//  API+Repo.swift
//  MGAPIService
//
//  Created by Tuan Truong on 4/8/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import ObjectMapper
import RxSwift

extension API {
    func getRepoList(_ input: GetRepoListInput) -> Observable<GetRepoListOutput> {
        return request(input)
    }
    
    func getEventList(_ input: GetEventListInput) -> Observable<[Event]> {
        return request(input)
    }
}

// MARK: - GetRepoList
extension API {
    final class GetRepoListInput: APIInput {
        init(page: Int, perPage: Int = 10) {
            let params: JSONDictionary = [
                "q": "language:swift",
                "per_page": perPage,
                "page": page
            ]
            super.init(urlString: API.Urls.getRepoList,
                       parameters: params,
                       requestType: .get,
                       requireAccessToken: true)
        }
    }
    
    final class GetRepoListOutput: APIOutput {
        private(set) var repos: [Repo]?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            repos <- map["items"]
        }
    }
}

// MARK: - GetEventList
extension API {
    final class GetEventListInput: APIInput {
        init(owner: String, repo: String, perPage: Int = 10) {
            let params: JSONDictionary = [
                "per_page": perPage
            ]
            let urlString = String(format: API.Urls.getEventList, owner, repo)
            super.init(urlString: urlString,
                       parameters: params,
                       requestType: .get,
                       requireAccessToken: true)
        }
    }
}
