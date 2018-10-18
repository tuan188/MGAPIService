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
            if requestType == .get || self is APIUploadInputBase {
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


extension APIInputBase: CustomStringConvertible {
    public var urlEncodingString: String {
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
    
    public var description: String {
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
    let data: Data
    let name: String
    let fileName: String
    let mimeType: String
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


