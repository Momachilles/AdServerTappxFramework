//
//  NetworkManager.swift
//  AdServerTappxFramework
//
//  Created by David Alarcon on 24/10/2016.
//  Copyright © 2016 4Crew. All rights reserved.
//

import Foundation

struct NetworkManagerConstants {
    private static let kProtocol = "http"
    private static let kHostname = "ssp.api.tappx.com"
    static var kBaseURL: String {
       return kProtocol + "://" + kHostname
    }
}

protocol ModelJSON {
    associatedtype T
    init(json: JSONDictionary<T>?) throws
}

//MARK: - NetworkError
enum NetworkError<S>: Error {
    case httpResponseNetworkError(S, Int)
    case genericNetworkError(S)
    case noNetworkNetworkError(S)
    case jsonNetworkError(S)
    
    func message() -> S {
        switch self {
        case .httpResponseNetworkError(let s, _):
            return s
        case .genericNetworkError(let s):
            return s
        case .noNetworkNetworkError(let s):
            return s
        case .jsonNetworkError(let s):
            return s
        }
    }
}

//MARK: - Network Calls
enum RequestType: String {
    case RequestAd = "/dev/mon_v1"
}

//MARK: - TappxResult
class TappxResult<T>: NSObject {
    let value: T
    let headers: TappxHeaders
    
    init(_ value: T, headers: TappxHeaders) {
        self.value = value
        self.headers = headers
    }
    
    func map<U>(_ f: (T) throws -> U) rethrows -> TappxResult<U> {
        return TappxResult<U>(try f(self.value), headers: self.headers)
    }
    
    func flatMap<U>(_ f: (T) throws -> TappxResult<U>) rethrows -> TappxResult<U> {
        return try f(self.value)
    }
    
}

infix operator >>  : MultiplicationPrecedence
infix operator >>> : MultiplicationPrecedence

func >><T, U>(left: TappxResult<T>, right: (T) throws -> U) rethrows -> TappxResult<U> {
    return try left.map(right)
}

func >>><T, U>(left: TappxResult<T>, right: (T) throws -> TappxResult<U>) rethrows -> TappxResult<U> {
    return try left.flatMap(right)
}


//MARK: - Result
//enum Result<T> {
//    case success(T)
//    case failure(NetworkError<String>)
//    case Unknown
//    
//    init(value: T? = .none, error: NetworkError<String>? = .none) {
//        if let err = error {
//            self = .failure(err)
//        } else if let v = value {
//            self = .success(v)
//        } else {
//            self = .Unknown
//        }
//    }
//    
//    func value() -> T? {
//        switch self {
//        case .success(let t):
//            return t
//        case .failure:
//            return .none
//        case .Unknown:
//            return .none
//        }
//    }
//}
//
//extension Result {
//    
//    func map<U>(f: (T)->U) -> Result<U> {
//        switch self {
//        case .success(let t): return .success(f(t))
//        case .failure(let err): return .failure(err)
//        case .Unknown: return .Unknown
//        }
//    }
//    
//    func flatMap<U>(f: (T) -> Result<U>) -> Result<U> {
//        switch self {
//        case .success(let t): return f(t)
//        case .failure(let err): return .failure(err)
//        case .Unknown:
//        return .Unknown
//        }
//    }
//}
//
//extension Result {
//    // Return the value if it's a .success or throw the error if it's a .failure
//    func resolve() throws -> T? {
//        switch self {
//        case .success(let value): return value
//        case .failure(let error): throw error
//        case .Unknown: return .none
//        }
//    }
//    
//    // Construct a .success if the expression returns a value or a .failure if it throws
//    init( _ throwingExpr: () throws -> T) {
//        do {
//            let value = try throwingExpr()
//            self = Result.success(value)
//        } catch (let error as NSError) {
//            self = Result.failure(.genericNetworkError(error.localizedDescription))
//        }
//    }
//}

enum OperationType {
    case Public
    case Private
    case Session
}

enum RequestPostType {
    case URLEncoded
    case JSON
    case Both
}

enum RequestPutType {
    case URLEncoded
    case JSON
    case Path
}

///JSON Typealias
typealias JSONDictionary<T> = Dictionary<String, T>
typealias JSONArray = Array<JSONDictionary<Any>>

///The default callback
typealias ResultCallback<T> = (_ result: Result<T>) -> ()

internal class NetworkManager: NSObject {
    static var sharedInstance: NetworkManager = NetworkManager()

    //MARK: Base methods
    fileprivate func request(type: RequestType, paramString: String?) ->  URLRequest? {
        let urlPath = NetworkManagerConstants.kBaseURL + type.rawValue + "?" + (paramString ?? "")
        guard let url = URL(string: urlPath) else { return .none }
        return URLRequest(url: url)
    }

private func http(request: URLRequest, callback: @escaping ResultCallback<Any>) -> URLSessionTask {
    
    print("Bytes sent: \(request.httpBody?.count)")
    let configuration = URLSessionConfiguration.default
    let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
    let task = session.dataTask(with: request as URLRequest){ (data: Data?, response: URLResponse?, error: Error?) in
        do {
            try self.parseResponse(data: data, response: response, error: error) { callback($0) }
        } catch {
            callback(.failure(error as! NetworkError<String>))
        }
    }
    task.resume()
    
    return task
}

private func parseResponse(data responseData: Data?, response: URLResponse?, error: Error?, callback: ResultCallback<Any>) throws -> () {
    
    if let error = error {
        let e = NetworkError.genericNetworkError(error.localizedDescription)
        let r = Result<Any>.failure(e)
        callback(r)
    }
    
    guard let response = response as? HTTPURLResponse else {
        callback(.failure(NetworkError.httpResponseNetworkError("Response is missing", 0)))
        return
    }
    
    guard let data = responseData else {
        callback(.failure(NetworkError.httpResponseNetworkError("No data present in response", response.statusCode)))
        return
    }
    
    guard let content = response.allHeaderFields["x-content"] as? String else { throw NetworkError.genericNetworkError("No content type defined") }
    
    switch response.statusCode {
        
    case 200 where content == "html": //Ok and it's html
        
        let dataString = String(data: data, encoding: String.Encoding.utf8)
        print("Data (\(data.count) bytes): \(dataString)")
        callback(.success(dataString ?? ""))
        
    case 200 where content == "no_fill": // OK and no fill
        print("No fill")
        callback(.success(""))
        
    default: // Error
        callback(.failure(NetworkError.genericNetworkError("Error in parseResponse: \(response.statusCode)")))
    }

}

    fileprivate func httpPost(request: inout URLRequest, bodyParameters: TappxBodyParameters, callback: @escaping ResultCallback<Any>) {
        request.httpMethod = "POST"
        
        //JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Mozilla/5.0 (Linux; Android 5.0.1; en-us; SM-N910V Build/LRX22C) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.93 Mobile Safari/537.36", forHTTPHeaderField: "User-Agent")
        do {
            //let jsonData = try JSONSerialization.data(withJSONObject: jsonParams, options: .prettyPrinted)
            //request.httpBody = jsonData
            request.httpBody = try bodyParameters.json()
            self.http(request: request) {
                callback($0)
            }
            
        } catch {
            callback(Result<Any>.failure(NetworkError.jsonNetworkError((error as NSError).localizedDescription)))
        }

        
    }
    
}

//MARK: - NSURLSessionDelegate methods
extension NetworkManager: URLSessionDelegate {}


//MARK: - Banner
extension NetworkManager {
    
    func interstitial(tappxQueryStringParameters: TappxQueryStringParameters, tappxBodyParameters: TappxBodyParameters, callback: @escaping ResultCallback<String>) {
        
        guard var request = self.request(type: .RequestAd, paramString: tappxQueryStringParameters.urlString()) else {
            callback(Result<String>.failure(NetworkError.genericNetworkError("Error in request")))
            return
        }
        self.httpPost(request: &request, bodyParameters: tappxBodyParameters) { data in
            
            //guard let data = data.value() as? String else { callback(.failure(NetworkError.GenericNetworkError("Data is not a string"))) }
            
            let result: Result<String> = data.flatMap { t in
                if let t = t as? String {
                    return .success(t)
                } else {
                    return .failure(NetworkError.genericNetworkError("Data is not a string"))
                }
            }
            
            callback(result)
        }

    }
    
    func banner(tappxQueryStringParameters: TappxQueryStringParameters, tappxBodyParameters: TappxBodyParameters, callback: @escaping ResultCallback<String>) {
        
        guard var request = self.request(type: .RequestAd, paramString: tappxQueryStringParameters.urlString()) else {
            callback(Result<String>.failure(NetworkError.genericNetworkError("Error in request")))
            return
        }
        self.httpPost(request: &request, bodyParameters: tappxBodyParameters) { data in
            
            //guard let data = data.value() as? String else { callback(.failure(NetworkError.GenericNetworkError("Data is not a string"))) }
            
            let result: Result<String> = data.flatMap { t in
                if let t = t as? String {
                    return .success(t)
                } else {
                    return .failure(NetworkError.genericNetworkError("Data is not a string"))
                }
            }
            
            callback(result)
        }
        
    }
    
    
}
