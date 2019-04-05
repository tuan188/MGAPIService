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
    func getRepoList() -> Observable<PagingInfo<Repo>>
    func loadMoreRepoList(page: Int) -> Observable<PagingInfo<Repo>>
}

struct RepoListUseCase: RepoListUseCaseType {
    func getRepoList() -> Observable<PagingInfo<Repo>> {
        return loadMoreRepoList(page: 1)
    }
    
    func loadMoreRepoList(page: Int) -> Observable<PagingInfo<Repo>> {
        return Observable.empty()
    }
}
