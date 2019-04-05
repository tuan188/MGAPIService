//
//  APIInputBase.swift
//  MGAPIService
//
//  Created by Tuan Truong on 4/5/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import Alamofire

open class APIInputBase {
    public var headers: [String: String] = [:]
    public let urlString: String
    public let requestType: HTTPMethod
    public let encoding: ParameterEncoding
    public let parameters: [String: Any]?
    public let requireAccessToken: Bool
    public var accessToken: String?
    public var useCache: Bool = false {
        didSet {
            if requestType != .get || self is APIUploadInputBase {
                fatalError()
            }
        }
    }
    public var user: String?
    public var password: String?
    
    public init(urlString: String,
         parameters: [String: Any]?,
         requestType: HTTPMethod,
         requireAccessToken: Bool) {
        self.urlString = urlString
        self.parameters = parameters
        self.requestType = requestType
        self.encoding = requestType == .get ? URLEncoding.default : JSONEncoding.default
        self.requireAccessToken = requireAccessToken
    }
}

extension APIInputBase {
    open var urlEncodingString: String {
        guard
            let url = URL(string: urlString),
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let parameters = parameters,
            requestType == .get
            else {
                return urlString
        }
        urlComponents.queryItems = parameters.map {
            return URLQueryItem(name: "\($0)", value: "\($1)")
        }
        return urlComponents.url?.absoluteString ?? urlString
    }
}

extension APIInputBase: CustomStringConvertible {
    open var description: String {
        if requestType == .get {
            return [
                "🌎 \(requestType.rawValue) \(urlEncodingString)"
                ].joined(separator: "\n")
        }
        return [
            "🌎 \(requestType.rawValue) \(urlString)",
            "Parameters: \(String(describing: parameters ?? JSONDictionary()))"
            ].joined(separator: "\n")
    }
}

public struct APIUploadData {
    public let data: Data
    public let name: String
    public let fileName: String
    public let mimeType: String
    
    public init(data: Data, name: String, fileName: String, mimeType: String) {
        self.data = data
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }
}

open class APIUploadInputBase: APIInputBase {
    public let data: [APIUploadData]
    
    public init(data: [APIUploadData],
         urlString: String,
         parameters: [String: Any]?,
         requestType: HTTPMethod,
         requireAccessToken: Bool) {
        
        self.data = data
        
        super.init(
            urlString: urlString,
            parameters: parameters,
            requestType: requestType,
            requireAccessToken: requireAccessToken
        )
    }
}
