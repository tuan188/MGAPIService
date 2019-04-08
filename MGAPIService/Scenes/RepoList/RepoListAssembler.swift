//
//  RepoListAssembler.swift
//  MGAPIService
//
//  Created by Tuan Truong on 4/5/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import UIKit

protocol RepoListAssembler {
    func resolve(navigationController: UINavigationController) -> RepoListViewController
    func resolve(navigationController: UINavigationController) -> RepoListViewModel
    func resolve(navigationController: UINavigationController) -> RepoListNavigatorType
    func resolve() -> RepoListUseCaseType
}

extension RepoListAssembler {
    func resolve(navigationController: UINavigationController) -> RepoListViewController {
        let vc = RepoListViewController.instantiate()
        let vm: RepoListViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }

    func resolve(navigationController: UINavigationController) -> RepoListViewModel {
        return RepoListViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve()
        )
    }
}

extension RepoListAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> RepoListNavigatorType {
        return RepoListNavigator(assembler: self, navigationController: navigationController)
    }

    func resolve() -> RepoListUseCaseType {
        return RepoListUseCase(repository: resolve())
    }
}
