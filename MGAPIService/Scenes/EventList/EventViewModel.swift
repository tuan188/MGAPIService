//
//  EventViewModel.swift
//  MGAPIService
//
//  Created by Tuan Truong on 5/27/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

struct EventViewModel {
    let event: Event
    
    var type: String {
        return event.type
    }
        
}
