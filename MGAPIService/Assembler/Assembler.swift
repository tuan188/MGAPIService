//
//  Assembler.swift
//  MGAPIService
//
//  Created by Tuan Truong on 4/5/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

protocol Assembler: class,
    EventListAssembler,
    RepositoriesAssembler,
    RepoListAssembler,
    AppAssembler {
    
}

final class DefaultAssembler: Assembler {
    
}
