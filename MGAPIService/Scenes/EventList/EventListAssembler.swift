//
//  EventListAssembler.swift
//  MGAPIService
//
//  Created by Tuan Truong on 5/27/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import UIKit

protocol EventListAssembler {
    func resolve(navigationController: UINavigationController, repo: Repo) -> EventListViewController
    func resolve(navigationController: UINavigationController, repo: Repo) -> EventListViewModel
    func resolve(navigationController: UINavigationController) -> EventListNavigatorType
    func resolve() -> EventListUseCaseType
}

extension EventListAssembler {
    func resolve(navigationController: UINavigationController, repo: Repo) -> EventListViewController {
        let vc = EventListViewController.instantiate()
        let vm: EventListViewModel = resolve(navigationController: navigationController, repo: repo)
        vc.bindViewModel(to: vm)
        return vc
    }

    func resolve(navigationController: UINavigationController, repo: Repo) -> EventListViewModel {
        return EventListViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve(),
            repo: repo
        )
    }
}

extension EventListAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> EventListNavigatorType {
        return EventListNavigator(assembler: self, navigationController: navigationController)
    }

    func resolve() -> EventListUseCaseType {
        return EventListUseCase(repository: resolve())
    }
}
