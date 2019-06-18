//
//  APIOutput.swift
//  MGAPIService
//
//  Created by Tuan Truong on 4/5/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import ObjectMapper

class APIOutput: APIOutputBase, ResponseHeader {  // swiftlint:disable:this final_class
    var header: [AnyHashable: Any]?
}
