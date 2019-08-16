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
        let eventList: Driver<[Event]>
        let selectedEvent: Driver<Void>
        let isEmpty: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let result = getList(
            loadTrigger: input.loadTrigger,
            reloadTrigger: input.reloadTrigger,
            getItems: { _ in
                self.useCase.getEventList(owner: self.repo.owner, repo: self.repo.name)
            })
        
        let (eventList, loadError, loading, refreshing) = result.destructured
        
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
        
        let isEmpty = checkIfDataIsEmpty(trigger: Driver.merge(loading, refreshing), items: eventList)
        
        return Output(
            error: loadError,
            loading: loading,
            refreshing: refreshing,
            eventList: eventList,
            selectedEvent: selectedEvent,
            isEmpty: isEmpty
        )
    }
}
