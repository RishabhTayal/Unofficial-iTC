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
                do {
                    let json = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments)
                    completionBlock(json, nil)
                } catch {
                    completionBlock(nil, error)
                }
            } else {
                completionBlock(nil, e)
            }
        }.resume()
    }

    class func getReviews(app: App, completionBlock: @escaping CompletionBlock) {
        URLSession.shared.dataTask(with: URL(string: "https://review-monitor.herokuapp.com/ratings?bundle_id=" + app.bundleId)!) { d, r, e in
            if let d = d {
                do {
                    let json = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments)
                    completionBlock(json, nil)
                } catch {
                    completionBlock(nil, error)
                }
            } else {
                completionBlock(nil, e)
            }
        }.resume()
    }

    class func postResponse(app: App, reviewId: String, response: String, completionBlock: @escaping CompletionBlock) {
        var request = URLRequest(url: URL(string: "https://review-monitor.herokuapp.com/ratings?bundle_id=" + app.bundleId)!)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { d, r, e in
            if let d = d {
                do {
                    let json = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments)
                    completionBlock(json, nil)
                } catch {
                    completionBlock(nil, error)
                }
            } else {
                completionBlock(nil, e)
            }
        }.resume()
    }
}
