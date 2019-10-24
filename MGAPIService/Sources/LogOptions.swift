//
//  LogOptions.swift
//  MGAPIService
//
//  Created by Tuan Truong on 8/19/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

public struct LogOptions: OptionSet {
    public let rawValue: Int
    
    static let request = LogOptions(rawValue: 1 << 0)
    static let requestParameters = LogOptions(rawValue: 1 << 1)
    static let rawRequest = LogOptions(rawValue: 1 << 2)
    static let urlResponse = LogOptions(rawValue: 1 << 3)
    static let responseStatus = LogOptions(rawValue: 1 << 4)
    static let responseData = LogOptions(rawValue: 1 << 5)
    static let error = LogOptions(rawValue: 1 << 6)
    static let cache = LogOptions(rawValue: 1 << 7)
    
    static let `default`: [LogOptions] = [
        .request,
        .requestParameters,
        .responseStatus,
        .error
    ]
    
    static let none: [LogOptions] = []
    
    static let all: [LogOptions] = [
        .request,
        .requestParameters,
        .rawRequest,
        .urlResponse,
        .responseStatus,
        .responseData,
        .error,
        .cache
    ]
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
