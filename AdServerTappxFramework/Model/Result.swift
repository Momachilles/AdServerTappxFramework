//
//  Result.swift
//  AdServerTappxFramework
//
//  Created by David Alarcon on 13/11/2016.
//  Copyright © 2016 4Crew. All rights reserved.
//

//MARK: - Operators
infix operator >>  : MultiplicationPrecedence
infix operator ->> : MultiplicationPrecedence

func >><T, U>(left: Result<T>, right: (T) -> U) -> Result<U> {
    return left.map(right)
}

func ->><T, U>(left: Result<T>, right: (T) -> Result<U>) -> Result<U> {
    return left.flatMap(right)
}

//MARK: - Protocol
protocol ResultType {
    associatedtype Value
    
    init(success value: Value)
    init(failure error: Error)
    
    func map<U>     (_ f: (Value) -> U) -> Result<U>
    func flatMap<U> (_ f: (Value) -> Result<U>) -> Result<U>
}

//MARK: - Result
public enum Result<T>: ResultType {
    case success(T)
    case failure(Error)
}

extension Result {
    
    init(success value: T) {
        self = .success(value)
    }
    
    init(failure error: Error) {
        self = .failure(error)
    }
    
    func value() -> T? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return .none
        }
    }
    
    func map<U>(_ f: (T) -> U) -> Result<U> {
        switch self {
        case .success(let value):
            return .success(f(value))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func flatMap<U>(_ f: (T) -> Result<U>) -> Result<U> {
        switch self {
        case .success(let value):
            return f(value)
        case .failure(let error):
            return .failure(error)
        }
    }
}

extension Result: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .success(let value):
            return "success: \(String(describing: value))"
        case .failure(let error):
            return "error: \(String(describing: error))"
        }
    }
}

extension Result: CustomStringConvertible {
    public var description: String {
        switch self {
        case .success(let value):
            return "success: \(String(describing: value))"
        case .failure(let error):
            return "error: \(String(describing: error))"
        }
    }
}

