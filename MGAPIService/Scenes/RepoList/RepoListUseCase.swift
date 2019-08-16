//
//  RepoListUseCase.swift
//  MGAPIService
//
//  Created by Tuan Truong on 4/5/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import RxSwift
import MGArchitecture

protocol RepoListUseCaseType {
    func getRepoList(page: Int) -> Observable<PagingInfo<Repo>>
}

struct RepoListUseCase: RepoListUseCaseType {
    let repository: RepoRepositoryType
    
    func getRepoList(page: Int) -> Observable<PagingInfo<Repo>> {
        return repository.getRepoList(page: page, perPage: 20, useCache: page == 1)
    }
}

