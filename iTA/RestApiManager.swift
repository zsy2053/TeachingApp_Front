//
//  RestApiManager.swift
//  iTA
//
//  Created by Shuyang Zang on 2018-07-18.
//  Copyright © 2018 Shuyang Zang. All rights reserved.
//
import SwiftyJSON
import Foundation
typealias ServiceResponse = (JSON, NSError?) -> Void
class ResetApiManager: NSObject {
    static let sharedInstance = ResetApiManager()
    
    let baseURL = "http://localhost:3001/"
    
    func makeHTTPGetRequest(path: String, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        let url = URL(string: path)
        let request = URLRequest(url: url!)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            do {
                if(error != nil) {
                    onFailure(error!)
                } else {
                    let result = try JSON(data: data!)
                    onSuccess(result)
                }
            } catch {
                print(error)
            }
        })
        task.resume()
    }
}
