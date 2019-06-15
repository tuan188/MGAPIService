//
//  RepoRepository.swift
//  MGAPIService
//
//  Created by Tuan Truong on 4/8/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import MGArchitecture
import RxSwift

protocol RepoRepositoryType {
    func getRepoList(page: Int, perPage: Int, useCache: Bool) -> Observable<PagingInfo<Repo>>
    func getEventList(owner: String, repo: String) -> Observable<[Event]>
}

final class RepoRepository: RepoRepositoryType {
    func getRepoList(page: Int, perPage: Int, useCache: Bool) -> Observable<PagingInfo<Repo>> {
        let input = API.GetRepoListInput(page: page, perPage: perPage)
        return API.shared.getRepoList(input)
            .map { output in
                guard let repos = output.repos else {
                    throw APIInvalidResponseError()
                }
                print(output.header as Any)
                return PagingInfo<Repo>(page: page, items: repos)
        }
    }
    
    func getEventList(owner: String, repo: String) -> Observable<[Event]> {
        let input = API.GetEventListInput(owner: owner, repo: repo, perPage: 10)
        return API.shared.getEventList(input)
    }
}
