//
//  RepoListViewModel.swift
//  MGAPIService
//
//  Created by Tuan Truong on 4/5/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import MGArchitecture
import RxSwift
import RxCocoa

struct RepoListViewModel {
    let navigator: RepoListNavigatorType
    let useCase: RepoListUseCaseType
}

// MARK: - ViewModelType
extension RepoListViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
        let selectRepoTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let error: Driver<Error>
        let loading: Driver<Bool>
        let reloading: Driver<Bool>
        let loadingMore: Driver<Bool>
        let repoList: Driver<[Repo]>
        let selectedRepo: Driver<Void>
        let isEmptyData: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let result = configPagination(
            loadTrigger: input.loadTrigger,
            reloadTrigger: input.reloadTrigger,
            loadMoreTrigger: input.loadMoreTrigger,
            getItems: useCase.getRepoList)
        
        let (page, loadError, loading, reloading, loadingMore) = result.destructured
        
        let repoList = page
            .map { $0.items }
        
        let selectedRepo = select(trigger: input.selectRepoTrigger, items: repoList)
            .do(onNext: navigator.toRepoDetail)
            .mapToVoid()
        
        let isEmpty = checkIfDataIsEmpty(trigger: Driver.merge(loading, reloading), items: repoList)
        
        return Output(
            error: loadError,
            loading: loading,
            reloading: reloading,
            loadingMore: loadingMore,
            repoList: repoList,
            selectedRepo: selectedRepo,
            isEmptyData: isEmpty
        )
    }
}
