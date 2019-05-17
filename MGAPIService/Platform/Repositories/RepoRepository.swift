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
}

final class RepoRepository: RepoRepositoryType {
    func getRepoList(page: Int, perPage: Int, useCache: Bool) -> Observable<PagingInfo<Repo>> {
        let input = API.GetRepoListInput(page: page, perPage: perPage)
//        input.useCache = useCache
        return API.shared.getRepoList(input)
            .map { output in
                guard let repos = output.repos else {
                    throw APIInvalidResponseError()
                }
                print(output.header)
                return PagingInfo<Repo>(page: page, items: repos)
        }
    }
}
