//
//  EventListNavigator.swift
//  MGAPIService
//
//  Created by Tuan Truong on 5/27/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import UIKit

protocol EventListNavigatorType {
    func toEventDetail(event: Event)
}

struct EventListNavigator: EventListNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController

    func toEventDetail(event: Event) {

    }
}
