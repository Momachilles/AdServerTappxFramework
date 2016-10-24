//
//  NetworkManager.swift
//  AdServerTappxFramework
//
//  Created by David Alarcon on 24/10/2016.
//  Copyright © 2016 4Crew. All rights reserved.
//

import Foundation

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
    case RequestBanner = "requestBanner"
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

//JSON Typealias
typealias JSONDictionary<T> = Dictionary<String, T>
typealias JSONArray = Array<JSONDictionary<Any>>

//The default callback
typealias ResultCallbackBlock<T> = (_ result: Result<T>) -> ()

internal class NetworkManager: NSObject {
    static var sharedInstance: NetworkManager = NetworkManager()

//MARK: Base methods
private func request(type: RequestType) ->  URLRequest? {
    guard let url = URL(string: type.rawValue) else { return .none }
    return URLRequest(url: url)
}

private func httpDelete( request: inout URLRequest, params: [String:String]?, type: OperationType, callback: @escaping ResultCallbackBlock<Any>) {
    request.httpMethod = "DELETE"
    if let params = params, let url = request.url {
        let parameterString = params.stringFromHttpParameters()
        let components = NSURLComponents(string: url.absoluteString)
        components?.query = parameterString
        request.url = components?.url ?? url
    }
    
    self.http(request: request, type: type) { callback($0) }
}

private func httpPut(request: inout URLRequest, params: [String:String]?, type: OperationType, putType: RequestPutType, callback: @escaping ResultCallbackBlock<Any>) {
    request.httpMethod = "PUT"
    if let p = params {
        
        switch putType {
        case .URLEncoded:
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let parameterString = p.stringFromHttpParameters()
            request.httpBody = parameterString.data(using: String.Encoding.utf8)
        case .JSON:
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: p, options: .prettyPrinted)
                request.httpBody = jsonData
            } catch {
                callback(Result(error: NetworkError.JSONNetworkError((error as NSError).localizedDescription)))
            }
        case .Path:
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        
        self.http(request: request, type: type, callback: callback)
    }
}

private func httpGet(request: inout URLRequest, params: [String:String]?, type: OperationType, callback: @escaping ResultCallbackBlock<Any>) {
    request.httpMethod = "GET"
    if let params = params, let url = request.url {
        let parameterString = params.stringFromHttpParameters(encoding: false)
        let components = NSURLComponents(string: url.absoluteString)
        components?.query = parameterString
        request.url = components?.url ?? url
    }
    
    self.http(request: request, type: type) { callback($0) }
}

private func httpPost(request: inout URLRequest, params: [String:String]?, type: OperationType, postType: RequestPostType, callback: @escaping ResultCallbackBlock<Any>) {
    request.httpMethod = "POST"
    if let p = params {
        
        switch postType {
        case .URLEncoded:
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let parameterString = p.stringFromHttpParameters()
            request.httpBody = parameterString.data(using: String.Encoding.utf8)
        case .JSON:
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: p, options: .prettyPrinted)
                request.httpBody = jsonData
            } catch {
                callback(Result(error: NetworkError.JSONNetworkError((error as NSError).localizedDescription)))
            }
        case .Both:
            
            guard let jsonParams = p["json"] as? [String: String] else { return }
            guard let pathParams = p["path"] as? [String: String] else { return }
            
            //URL encoded
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let parameterString = pathParams.stringFromHttpParameters()
            request.httpBody = parameterString.data(using: String.Encoding.utf8)
            
            //JSON
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonParams, options: .prettyPrinted)
                request.httpBody = jsonData
            } catch {
                callback(Result(error: NetworkError.JSONNetworkError((error as NSError).localizedDescription)))
            }
            
            break
        }
        self.http(request: request, type: type) { callback($0) }
    }
}

private func http(request: URLRequest, type: OperationType, callback: @escaping ResultCallbackBlock<Any>) -> URLSessionTask {
    
    switch type {
    case .Public:
        /*
         if let token = self.openToken {
         request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
         }
         */
        break
    case .Private: break
        /*
        if let token = self.sessionToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        */
    default: break
    }
    
    let configuration = URLSessionConfiguration.default
    let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
    let task = session.dataTask(with: request as URLRequest){ (data: Data?, response: URLResponse?, error: Error?) in
        do {
            let invalidToken = try self.parseResponse(data: data, response: response, type: type, error: error) { callback($0) }
            if invalidToken {
                /*
                self.invalidToken = true
                self.refreshToken { result in
                    switch result {
                    case .Success( _):
                        self.http(request, type: type) { callback(result: $0) }
                    case .Unknown:
                        callback(result: .Failure(.RefreshTokenNetworkError("Refresh token seems expired. Please login again")))
                    case .Failure(let error):
                        callback(result: .Failure(error))
                        
                    }
                    
                }
                */
            } else {
                
            }
        } catch {
            callback(.Failure(error as! NetworkError<String>))
        }
    }
    task.resume()
    return task
}

private func parseResponse(data: Data?, response: URLResponse?, type: OperationType, error: Error?, callback: ResultCallbackBlock<Any>) throws -> Bool {
    
    if let error = error {
        let e = NetworkError.GenericNetworkError(error.localizedDescription)
        let r = Result<Any>(error: e)
        callback(r)
        return false
    }
    
    guard let data = data else { throw NetworkError.ResponseNetworkError("No data present in response") }
    guard let response = response as? HTTPURLResponse else { throw NetworkError.ResponseNetworkError("Response is missing") }

    //let dataString = String(data: data, encoding: String.Encoding.utf8)
    //logger.debug("Data: \(dataString)")
    
    switch response.statusCode {
        
    case 200: //Ok
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            callback(.Success(json))
        } catch {
            callback(.Success("")) // Empty response data
        }
        
    case 401...403: break // Invalid Token
        
        /*
        if self.invalidToken {
            callback(result: .Failure(.RefreshTokenNetworkError("Refresh token seems expired. Please login again")))
            return false
        } else {
            return true
        }
        */
        /*
         if self.refreshTokenIsBeingChecked {
         self.refreshTokenIsBeingChecked = false
         self.refreshToken { result in
         switch result {
         case .Success:
         self.refreshTokenIsBeingChecked = true
         callback(result: .Success(""))
         case .Failure( _):
         fallthrough
         case .Unknown:
         callback(result: .Failure(.RefreshTokenNetworkError("Refresh token seems expired. Please login again")))
         }
         }
         return true
         } else {
         callback(result: .Failure(.RefreshTokenNetworkError("Refresh token seems expired. Please login again")))
         return false
         }
         */
        
    case 400 where type == .Session: break
        
        /*
        if self.invalidToken {
            callback(result: .Failure(.RefreshTokenNetworkError("Refresh token seems expired. Please login again")))
            return false
        } else {
            return true
        }
        */
        
    default: // Error
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            if let message = self.parseErrorFromJSON(json: json as? [String : String]) {
                //callback(result: .Failure(NetworkError.ResponseNetworkError("Code: \(response.statusCode). \(message)")))
                callback(.Failure(NetworkError.ResponseNetworkError("\(message)")))
            } else {
                callback(.Failure(NetworkError.GenericNetworkError("Error in parseResponse")))
            }
        } catch let error {
            callback(.Failure(NetworkError.GenericNetworkError((error as NSError).localizedDescription)))
        } /*catch {
         callback(result: .Failure(NetworkError.GenericNetworkError("Error in parseResponse")))
         logger.error("Error in parseResponse")
         }*/
    }
    
    
    
    return false
}

private func parseErrorFromJSON(json: [String: String]?) -> String? {
    
    //let errorType = json?["error"] ?? json?["code"] ?? .none
    let message = json?["error_description"] ?? json?["message"] ?? .none
    
    //guard let error = errorType, let msg = message else { return .none }
    guard let msg = message else { return .none }
    //return "Error: \(error). Description: \(msg)"
    return msg
}

}

//MARK: - NSURLSessionDelegate methods
extension NetworkManager: URLSessionDelegate {}
