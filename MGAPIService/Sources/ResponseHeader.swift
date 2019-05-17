//
//  ResponseHeader.swift
//  MGAPIService
//
//  Created by Tuan Truong on 5/16/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import UIKit

public protocol ResponseHeader: class {
    var header: [AnyHashable : Any]? { get set }
}
