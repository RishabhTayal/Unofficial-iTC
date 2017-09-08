//
//  ServiceCaller.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/7/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit

class ServiceCaller: NSObject {

    typealias CompletionBlock = ((_ result: Any?, _ error: Error?) -> Void)

    class func getApps(completionBlock: @escaping CompletionBlock) {
        URLSession.shared.dataTask(with: URL(string: "https://review-monitor.herokuapp.com")!) { d, r, e in
            if let d = d {
                let json = try! JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments)
                completionBlock(json, nil)
            }
        }.resume()
    }

    class func getReviews(completionBlock: @escaping CompletionBlock) {
        URLSession.shared.dataTask(with: URL(string: "https://review-monitor.herokuapp.com/ratings")!) { d, r, e in
            if let d = d {
                let json = try! JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments)
                completionBlock(json, nil)
            }
        }.resume()
    }
}
