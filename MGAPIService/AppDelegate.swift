//
//  AppDelegate.swift
//  MGAPIService
//
//  Created by Tuan Truong on 4/5/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var assembler: Assembler = DefaultAssembler()
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        bindViewModel()
    }
    
    private func bindViewModel() {
        guard let window = window else { return }
        
        let vm: AppViewModel = assembler.resolve(window: window)
        let input = AppViewModel.Input(loadTrigger: Driver.just(()))
        let output = vm.transform(input)
        output.toRepoList
            .drive()
            .disposed(by: rx.disposeBag)
    }
}
