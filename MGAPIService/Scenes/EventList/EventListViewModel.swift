//
//  EventListViewModel.swift
//  MGAPIService
//
//  Created by Tuan Truong on 5/27/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import MGArchitecture
import RxSwift
import RxCocoa

struct EventListViewModel {
    let navigator: EventListNavigatorType
    let useCase: EventListUseCaseType
    let repo: Repo
}

// MARK: - ViewModelType
extension EventListViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
        let selectEventTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let error: Driver<Error>
        let loading: Driver<Bool>
        let refreshing: Driver<Bool>
        let loadingMore: Driver<Bool>
        let fetchItems: Driver<Void>
        let eventList: Driver<[Event]>
        let selectedEvent: Driver<Void>
        let isEmptyData: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let loadMoreOutput = configPagination(
            loadTrigger: input.loadTrigger,
            getItems: {
                self.useCase.getEventList(owner: self.repo.owner, repo: self.repo.name)
            },
            reloadTrigger: input.reloadTrigger,
            reloadItems: {
                self.useCase.getEventList(owner: self.repo.owner, repo: self.repo.name)
            },
            loadMoreTrigger: input.loadMoreTrigger,
            loadMoreItems: { page in
                self.useCase.loadMoreEventList(owner: self.repo.owner, repo: self.repo.name, page: page)
            })
        
        let (page, fetchItems, loadError, loading, refreshing, loadingMore) = loadMoreOutput
        
        let eventList = page
            .map { $0.items.map { $0 } }
            .asDriverOnErrorJustComplete()
        
        let selectedEvent = input.selectEventTrigger
            .withLatestFrom(eventList) {
                return ($0, $1)
            }
            .map { indexPath, eventList in
                return eventList[indexPath.row]
            }
            .do(onNext: { event in
                self.navigator.toEventDetail(event: event)
            })
            .mapToVoid()
        
        let isEmptyData = Driver.combineLatest(fetchItems, Driver.merge(loading, refreshing))
            .withLatestFrom(eventList) { ($0.1, $1.isEmpty) }
            .map { args -> Bool in
                let (loading, isEmpty) = args
                if loading { return false }
                return isEmpty
            }
        
        return Output(
            error: loadError,
            loading: loading,
            refreshing: refreshing,
            loadingMore: loadingMore,
            fetchItems: fetchItems,
            eventList: eventList,
            selectedEvent: selectedEvent,
            isEmptyData: isEmptyData
        )
    }
}
