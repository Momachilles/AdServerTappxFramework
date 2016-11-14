//
//  TappxSignaler.swift
//  AdServerTappxFramework
//
//  Created by David Alarcon on 14/11/2016.
//  Copyright © 2016 4Crew. All rights reserved.
//

import Foundation

typealias BannerFuture = Future<Banner>

enum TappxError: Error {
    case noData
    case offline
}

extension TappxError {
    init(error: TaskError) {
        switch error {
        case .offline:
            self = TappxError.offline
        default:
            self = TappxError.noData
        }
    }
}

extension TappxError: CustomStringConvertible {
    var description: String {
        switch self {
        case .offline:
            return NSLocalizedString("Connection is Offline", comment: "Connection is Offline")
        case .noData:
            return NSLocalizedString("No Data Received", comment: "No Data Received")
        }
    }
}

final class TappxSignaler: NSObject {
    
    private let controller = NetworkController()
    private let error: Error? = .none
    
    func future() -> BannerFuture {
        
        let future: BannerFuture = Future { [unowned self] completion in
            
            //TODO: QueryParameters!!
            
            guard let request = self.controller.request(endpoint: .requestAd) else { return completion(.failure(TappxError.noData)) }
            let taskFuture = self.controller.data(for: request)
            
            taskFuture.start({ [unowned self] result in
                let bannerResult = result ->> self.banner  //result.flatMap(self.banner)
                completion(bannerResult)
                self.controller.finishSession()
            })
        }
        
        return future
        
    }
    
    private func banner(from data: Data) -> Result<Banner> {
        guard let dataString = String(data: data, encoding: String.Encoding.utf8) else { return .failure(TappxError.noData) }
        return .success(Banner(with: dataString))
    }
    
    
    
    

}
