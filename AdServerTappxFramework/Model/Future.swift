//
//  Future.swift
//  AdServerTappxFramework
//
//  Created by David Alarcon on 13/11/2016.
//  Copyright © 2016 4Crew. All rights reserved.
//

import Foundation

public protocol FutureType {
    associatedtype Value
    
    init(value: Value)
}

public struct Future<T>: FutureType {
    
    public typealias ResultType = Result<T>
    public typealias Completion = (ResultType) -> ()
    public typealias AsyncOperation = (@escaping Completion) -> ()
    
    private let operation: AsyncOperation
    
    public init(value result: ResultType) {
        self.init { completion in
            completion(result)
        }
    }
    
    public init(operation: @escaping AsyncOperation) {
        self.operation = operation
    }
    
    public func start(_ completion: @escaping Completion) {
        self.operation { result in
            completion(result)
        }
    }
}
