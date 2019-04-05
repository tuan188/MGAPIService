//
//  AppNavigator.swift
//  MGAPIService
//
//  Created by Tuan Truong on 4/5/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import UIKit

protocol AppNavigatorType {
    func toRepoList()
}

struct AppNavigator: AppNavigatorType {
    unowned let assembler: Assembler
    unowned let window: UIWindow
    
    func toRepoList() {
        let nav = UINavigationController()
        let vc: RepoListViewController = assembler.resolve(navigationController: nav)
        nav.viewControllers = [vc]
        window.rootViewController = nav
    }
}
