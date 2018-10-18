import UIKit

public protocol APIError: LocalizedError {
    var statusCode: Int? { get }
}

public extension APIError {
    public var statusCode: Int? { return nil }
}

public struct APIInvalidResponseError: APIError {
    
    public init() {
        
    }
    
    public var errorDescription: String? {
        return NSLocalizedString("api.invalidResponseError", comment: "")
    }
}

public struct APIUnknownError: APIError {
    
    public let statusCode: Int?
    
    public init(statusCode: Int?) {
        self.statusCode = statusCode
    }
    
    public var errorDescription: String? {
        return NSLocalizedString("api.unknownError", comment: "")
    }
}

