//
//  Event.swift
//  MGAPIService
//
//  Created by Tuan Truong on 5/27/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import UIKit
import Then
import ObjectMapper

struct Event {
    var id: String
    var type: String
}

extension Event: Equatable {
    
}

extension Event {
    init() {
        self.init(
            id: "",
            type: ""
        )
    }
}

extension Event: Then { }

extension Event: Mappable {
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        type <- map["type"]
    }
}
