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
        input.useCache = true
        
        return API.shared.getRepoList(input)
            .do(onNext: { _ in
                print("getRepoList")
            })
            .map { $0.repos }
            .unwrap()
            .distinctUntilChanged { $0 == $1 }
            .map { repos in
                return PagingInfo<Repo>(page: page, items: repos)
            }
            .do(onNext: { _ in
                print("getRepoList done")
            })
    }
    
    func getEventList(owner: String, repo: String) -> Observable<[Event]> {
        let input = API.GetEventListInput(owner: owner, repo: repo, perPage: 10)
        input.useCache = true
        
        return API.shared.getEventList(input)
            .distinctUntilChanged { $0 == $1 }
            .do(onNext: { _ in
                print("getEventList")
            })
    }
}
