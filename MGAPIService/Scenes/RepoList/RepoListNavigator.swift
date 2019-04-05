//
//  RepoListNavigator.swift
//  MGAPIService
//
//  Created by Tuan Truong on 4/5/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import UIKit

protocol RepoListNavigatorType {
    func toRepoDetail(repo: Repo)
}

struct RepoListNavigator: RepoListNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController

    func toRepoDetail(repo: Repo) {

    }
}
