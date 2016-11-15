//
//  NetworkController.swift
//  AdServerTappxFramework
//
//  Created by David Alarcon on 13/11/2016.
//  Copyright © 2016 4Crew. All rights reserved.
//

import Foundation

struct NetworkConstants {
    private static let kProtocol = "http"
    private static let kHostname = "ssp.api.tappx.com"
    static var kBaseURL: String { return kProtocol + "://" + kHostname }
}

enum NetworkEndpoint: String {
    
    case requestAd = "/dev/mon_v1"
    
    func path() -> String {
        return self.rawValue
    }
    
}

public typealias TaskResult = Result<Data>
public typealias TaskFuture = Future<Data>
public typealias TaskCompletion = (Data?, URLResponse?, Error?) -> ()

public enum TaskError: Error {
    case offline
    case noData
    case badResponse
    case badStatusCode(Int)
    case other(Error)
}

public struct NetworkController: Reachable {
    
    fileprivate let configuration: URLSessionConfiguration
    fileprivate let session: URLSession
    
    init(with configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        let queue = OperationQueue.main
        
        self.configuration = configuration
        self.session = URLSession(configuration: configuration, delegate: .none, delegateQueue: queue)
    }
    
    public func data(for request: URLRequest) -> TaskFuture {
        
        let future: TaskFuture = Future() { completion in
            
            let fulfill: (_ result: TaskResult) -> () = { taskResult in
                
//                switch taskResult {
//                case .success(let data):
//                    completion(.success(data))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
                
                completion(taskResult)
                
            }
            
            let completion: TaskCompletion = { (data, response, error) in
                
                print("Data: \(data)")
                print("Response: \(response)")
                print("Error: \(error)")
                
                guard let data = data else {
                    guard let error = error else { return fulfill(.failure(TaskError.noData)) }
                    return fulfill(.failure(TaskError.other(error)))
                }
                
                guard let response = response as? HTTPURLResponse else {
                    return fulfill(.failure(TaskError.badResponse))
                }
                
                switch response.statusCode {
                case 200...204:
                    fulfill(.success(data))
                default:
                    fulfill(.failure(TaskError.badStatusCode(response.statusCode)))
                }
            }
            
            let task = self.session.dataTask(with: request, completionHandler: completion)
            
            switch self.reachable {
            case .online:
                task.resume()
            case .offline:
                fulfill(.failure(TaskError.offline))
            }
            
        }
        
        return future
        
    }
    
    func request(endpoint: NetworkEndpoint, queryParams: QueryStringParameters = QueryStringParameters(), bodyParams: PostBodyParameters = PostBodyParameters.initDefault()) ->  URLRequest? {
        let paramString = queryParams.urlString()
        let urlPath = NetworkConstants.kBaseURL + endpoint.path() + "?" + paramString
        guard let url = URL(string: urlPath) else { return .none }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        //JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Mozilla/5.0 (Linux; Android 5.0.1; en-us; SM-N910V Build/LRX22C) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.93 Mobile Safari/537.36", forHTTPHeaderField: "User-Agent")
        do {
            request.httpBody = try bodyParams.json()
            return request
        } catch {
            return .none
        }
    }
    
    func finishSession() {
        self.session.finishTasksAndInvalidate()
    }
    
}
