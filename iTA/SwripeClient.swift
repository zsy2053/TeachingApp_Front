//
//  SwripeClient.swift
//  iTA
//
//  Created by xiande Yang on 2018-08-30.
//  Copyright © 2018 Shuyang Zang. All rights reserved.
//

import Foundation
import Alamofire
import Stripe

enum Result {
    case success
    case failure(Error)
}

final class StripeClient {
    
    static let shared = StripeClient()
    
    private init() {
        // private
    }
    
    private lazy var baseURL: URL = {
        guard let url = URL(string: "http://localhost:3001") else {
            fatalError("Invalid URL")
        }
        return url
    }()
    
    func completeCharge(with token: STPToken, amount: Int, completion: @escaping (Result) -> Void) {
        print("asfsfs")
        // 1
        let url = baseURL.appendingPathComponent("charge")
        // 2
        print(token)
        let params: [String: Any] = [
            "token": token.tokenId,
            "amount": amount,
            "currency": "cad",
            "description": "iTA tuition"
        ]
        // 3
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success:
                    completion(Result.success)
                case .failure(let error):
                    completion(Result.failure(error))
                }
        }
    }
    
}
