//
//  APIServiceBase.swift
//  MGAPIService
//
//  Created by Tuan Truong on 4/5/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import ObjectMapper
import Alamofire
import RxSwift
import RxAlamofire

public typealias JSONDictionary = [String: Any]
public typealias JSONArray = [JSONDictionary]

public protocol JSONData {
    init()
    static func equal(left: JSONData, right: JSONData) -> Bool
}

extension Dictionary: JSONData {
    static public func equal(left: JSONData, right: JSONData) -> Bool {
        return NSDictionary(dictionary: left as! JSONDictionary).isEqual(to: right as! JSONDictionary)
    }
}

extension Array: JSONData {
    static public func equal(left: JSONData, right: JSONData) -> Bool {
        let leftArray = left as! JSONArray
        let rightArray = right as! JSONArray
        guard leftArray.count == rightArray.count else { return false }
        for i in 0..<leftArray.count {
            if !JSONDictionary.equal(left: leftArray[i], right: rightArray[i]) {
                return false
            }
        }
        return true
    }
}

open class APIBase {
   
    public var manager: Alamofire.SessionManager
    
    public init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        manager = Alamofire.SessionManager(configuration: configuration)
    }
    
    open func request<T: Mappable>(_ input: APIInputBase) -> Observable<T> {
        let response: Observable<JSONDictionary> = request(input)
        return response
            .map { json -> T in
                if let t = T(JSON: json) {
                    return t
                }
                throw APIInvalidResponseError()
            }
    }
    
    open func request<T: Mappable>(_ input: APIInputBase) -> Observable<[T]> {
        let response: Observable<JSONArray> = request(input)
        return response
            .map { json -> [T] in
                return Mapper<T>().mapArray(JSONArray: json)
            }
    }
    
    open func request<U: JSONData>(_ input: APIInputBase) -> Observable<U> {
        let user = input.user
        let password = input.password
        let urlRequest = preprocess(input)
            .do(onNext: { input in
                print(input)
            })
            .flatMapLatest { [unowned self] input -> Observable<DataRequest> in
                if let uploadInput = input as? APIUploadInputBase {
                    return self.manager.rx
                        .upload(to: uploadInput.urlString,
                                method: uploadInput.requestType,
                                headers: uploadInput.headers) { (multipartFormData) in
                                    input.parameters?.forEach { key, value in
                                        if let data = String(describing: value).data(using:.utf8) {
                                            multipartFormData.append(data, withName: key)
                                        }
                                    }
                                    uploadInput.data.forEach({
                                        multipartFormData.append(
                                            $0.data,
                                            withName: $0.name,
                                            fileName: $0.fileName,
                                            mimeType: $0.mimeType)
                                    })
                        }
                        .map { $0 as DataRequest }
                } else {
                    return self.manager.rx
                        .request(input.requestType,
                                 input.urlString,
                                 parameters: input.parameters,
                                 encoding: input.encoding,
                                 headers: input.headers)
                }
            }
            .do(onNext: { (_) in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                }
            })
            .flatMapLatest { dataRequest -> Observable<(HTTPURLResponse, Data)> in
                if let user = user, let password = password {
                    return dataRequest
                        .authenticate(user: user, password: password)
                        .rx.responseData()
                }
                return dataRequest.rx.responseData()
            }
            .do(onNext: { (_) in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }, onError: { (_) in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            })
            .map { (dataResponse) -> U in
                return try self.process(dataResponse)
            }
            .catchError { [unowned self] error -> Observable<U> in
                return try self.handleRequestError(error, input: input)
            }
            .do(onNext: { (json) in
                if input.useCache {
                    DispatchQueue.global().async {
                        try? CacheManager.sharedInstance.write(urlString: input.urlEncodingString, data: json)
                    }
                }
            })
        
        let cacheRequest = Observable.just(input)
            .filter { $0.useCache }
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global()))
            .map {
                try CacheManager.sharedInstance.read(urlString: $0.urlEncodingString)
            }
            .catchError { error in
                print(error)
                return Observable.empty()
            }
            .map { $0 as! U }
        return input.useCache
            ? Observable.concat(cacheRequest, urlRequest).distinctUntilChanged(U.equal)
            : urlRequest
    }
    
    open func preprocess(_ input: APIInputBase) -> Observable<APIInputBase> {
        return Observable.just(input)
    }
    
    open func process<U: JSONData>(_ response: (HTTPURLResponse, Data)) throws -> U {
        let (response, data) = response
        let json: U? = (try? JSONSerialization.jsonObject(with: data, options: [])) as? U
        let error: Error
        let statusCode = response.statusCode
        switch statusCode {
        case 200..<300:
            print("👍 [\(statusCode)] " + (response.url?.absoluteString ?? ""))
            return json ?? U.init()
        default:
            error = handleResponseError(response: response, data: data, json: json)
            print("❌ [\(statusCode)] " + (response.url?.absoluteString ?? ""))
            if let json = json {
                print(json)
            } else {
                print(data)
            }
        }
        throw error
    }
    
    open func handleRequestError<U: JSONData>(_ error: Error, input: APIInputBase) throws -> Observable<U> {
        throw error
    }
    
    open func handleResponseError<U: JSONData>(response: HTTPURLResponse, data: Data, json: U?) -> Error {
        if let jsonDictionary = json as? JSONDictionary {
            return handleResponseError(response: response, data: data, json: jsonDictionary)
        } else if let jsonArray = json as? JSONArray {
            return handleResponseError(response: response, data: data, json: jsonArray)
        }
        return APIUnknownError(statusCode: response.statusCode)
    }
    
    open func handleResponseError(response: HTTPURLResponse, data: Data, json: JSONDictionary?) -> Error {
        return APIUnknownError(statusCode: response.statusCode)
    }
    
    open func handleResponseError(response: HTTPURLResponse, data: Data, json: JSONArray?) -> Error {
        return APIUnknownError(statusCode: response.statusCode)
    }
}
