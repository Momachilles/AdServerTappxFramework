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
    static let kBaseURL: String {
       return kProtocol + "://" + kHostname
    }
}

protocol ModelJSON {
    associatedtype T
    init(json: JSONDictionary<T>?) throws
}

//MARK: - NetworkError
enum NetworkError<S>: Error {
    case ResponseNetworkError(S)
    case TokenNetworkError(S)
    case RefreshTokenNetworkError(S)
    case GenericNetworkError(S)
    case NoNetworkNetworkError(S)
    case JSONNetworkError(S)
    case UnkownResultNetworkError(S)
    
    func message() -> S {
        switch self {
        case .ResponseNetworkError(let s):
            return s
        case .TokenNetworkError(let s):
            return s
        case .GenericNetworkError(let s):
            return s
        case .NoNetworkNetworkError(let s):
            return s
        case .JSONNetworkError(let s):
            return s
        case .UnkownResultNetworkError(let s):
            return s
        case .RefreshTokenNetworkError(let s):
            return s
        }
    }
}

//MARK: - Network Calls
enum RequestType: String {
    case RequestAd = "/dev/mon_v1"
}

//MARK: - Result
enum Result<T> {
    case Success(T)
    case Failure(NetworkError<String>)
    case Unknown
    
    init(value: T? = .none, error: NetworkError<String>? = .none) {
        if let err = error {
            self = .Failure(err)
        } else if let v = value {
            self = .Success(v)
        } else {
            self = .Unknown
        }
    }
    
    func value() -> T? {
        switch self {
        case .Success(let t):
            return t
        case .Failure:
            return .none
        }
    }
}

extension Result {
    
    func map<U>(f: (T)->U) -> Result<U> {
        switch self {
        case .Success(let t): return .Success(f(t))
        case .Failure(let err): return .Failure(err)
        case .Unknown: return .Unknown
        }
    }
    
    func flatMap<U>(f: (T) -> Result<U>) -> Result<U> {
        switch self {
        case .Success(let t): return f(t)
        case .Failure(let err): return .Failure(err)
        case .Unknown:
        return .Unknown
        }
    }
}

extension Result {
    // Return the value if it's a .Success or throw the error if it's a .Failure
    func resolve() throws -> T? {
        switch self {
        case .Success(let value): return value
        case .Failure(let error): throw error
        case .Unknown: return .none
        }
    }
    
    // Construct a .Success if the expression returns a value or a .Failure if it throws
    init( _ throwingExpr: () throws -> T) {
        do {
            let value = try throwingExpr()
            self = Result.Success(value)
        } catch (let error as NSError) {
            self = Result.Failure(.GenericNetworkError(error.localizedDescription))
        }
    }
}

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
            callback(.Failure(error as! NetworkError<String>))
        }
    }
    task.resume()
    
    return task
}

private func parseResponse(data: Data?, response: URLResponse?, error: Error?, callback: ResultCallback<Any>) throws -> Bool {
    
    if let error = error {
        let e = NetworkError.GenericNetworkError(error.localizedDescription)
        let r = Result<Any>(error: e)
        callback(r)
        return false
    }
    
    guard let data = data else { throw NetworkError.ResponseNetworkError("No data present in response") }
    guard let response = response as? HTTPURLResponse else { throw NetworkError.ResponseNetworkError("Response is missing") }
    guard let content = response.allHeaderFields["x-content"] as? String else { throw NetworkError.ResponseNetworkError("No content type defined") }

    let dataString = String(data: data, encoding: String.Encoding.utf8)
    print("Data (\(data.count) bytes): \(dataString)")
    
    switch response.statusCode {
        
    case 200 where content == "html": //Ok and it's html
        
        do {
            callback(.Success(dataString))
        } catch {
            callback(.Success("")) // Empty response data
        }
        
    case 200 where content == "no_fill": // OK and no fill
        print("No fill")
        callback(.Success(""))
        
    default: // Error
        callback(.Failure(NetworkError.GenericNetworkError("Error in parseResponse: \(response.statusCode)")))
    }
    
    
    
    return false
}

    fileprivate func httpPost(request: inout URLRequest, callback: @escaping ResultCallback<Any>) {
        request.httpMethod = "POST"
        
        //JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Mozilla/5.0 (Linux; Android 5.0.1; en-us; SM-N910V Build/LRX22C) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.93 Mobile Safari/537.36", forHTTPHeaderField: "User-Agent")
        do {
            //let jsonData = try JSONSerialization.data(withJSONObject: jsonParams, options: .prettyPrinted)
            //request.httpBody = jsonData
            request.httpBody = try TappxBodyParameters().json()
            self.http(request: request) { callback($0) }
            
        } catch {
            callback(Result(error: NetworkError.JSONNetworkError((error as NSError).localizedDescription)))
        }

        
    }
    
}

//MARK: - NSURLSessionDelegate methods
extension NetworkManager: URLSessionDelegate {}


//MARK: - Banner
extension NetworkManager {
    
    func interstittial(tappxQueryStringParameters: TappxQueryStringParameters, tappxBodyParameters: TappxBodyParameters, callback: @escaping ResultCallback<Any>) {
        
        guard var request = self.request(type: .RequestAd, paramString: tappxQueryStringParameters.urlString()) else {
            callback(.Unknown)
            return
        }
        self.httpPost(request: &request) { callback($0) }

    }
    
    func banner(tappxQueryStringParameters: TappxQueryStringParameters, tappxBodyParameters: TappxBodyParameters, callback: @escaping ResultCallback<String>) {
        
        guard var request = self.request(type: .RequestAd, paramString: tappxQueryStringParameters.urlString()) else {
            callback(.Unknown)
            return
        }
        self.httpPost(request: &request) { data in
            
            //guard let data = data.value() as? String else { callback(.Failure(NetworkError.GenericNetworkError("Data is not a string"))) }
            
            let result: Result<String> = data.flatMap { t in
                if let t = t as? String {
                    return .Success(t)
                } else {
                    return .Failure(NetworkError.GenericNetworkError("Data is not a string"))
                }
            }
            
            callback(result)
        }
        
    }
    
    
}
