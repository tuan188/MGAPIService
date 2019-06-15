//
//  EventListUseCase.swift
//  MGAPIService
//
//  Created by Tuan Truong on 5/27/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import RxSwift
import RxCocoa
import MGArchitecture

protocol EventListUseCaseType {
    func getEventList(owner: String, repo: String) -> Observable<PagingInfo<Event>>
    func loadMoreEventList(owner: String, repo: String, page: Int) -> Observable<PagingInfo<Event>>
}

struct EventListUseCase: EventListUseCaseType {
    let repository: RepoRepositoryType
    
    func getEventList(owner: String, repo: String) -> Observable<PagingInfo<Event>> {
        return repository.getEventList(owner: owner, repo: repo)
            .map { events in
                PagingInfo<Event>(page: 1, items: events)
            }
    }
    
    func loadMoreEventList(owner: String, repo: String, page: Int) -> Observable<PagingInfo<Event>> {
        return Observable.empty()
    }
}
