//
//  RepositoriesAssembler.swift
//  MGAPIService
//
//  Created by Tuan Truong on 4/8/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

protocol RepositoriesAssembler {
    func resolve() -> RepoRepositoryType
}

extension RepositoriesAssembler where Self: DefaultAssembler {
    func resolve() -> RepoRepositoryType {
        return RepoRepository()
    }
    
}

