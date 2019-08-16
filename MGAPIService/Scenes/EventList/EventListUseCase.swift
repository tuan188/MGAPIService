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
    func getEventList(owner: String, repo: String) -> Observable<[Event]>
}

struct EventListUseCase: EventListUseCaseType {
    let repository: RepoRepositoryType
    
    func getEventList(owner: String, repo: String) -> Observable<[Event]> {
        return repository.getEventList(owner: owner, repo: repo)
    }
}
