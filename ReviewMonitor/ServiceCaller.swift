//
//  ServiceCaller.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/7/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit

class ServiceCaller: NSObject {

    private static let BaseURL = "https://review-monitor.herokuapp.com/"

    private enum EndPoint: String {
        case apps
        case ratings
        case response
    }

    private enum HTTPMethod: String {
        case GET
        case POST
        case Delete
    }

    typealias CompletionBlock = ((_ result: Any?, _ error: Error?) -> Void)

    class func getApps(completionBlock: CompletionBlock?) {
        makeAPICall(endPoint: .apps, completionBlock: completionBlock)
    }

    class func getReviews(app: App, completionBlock: CompletionBlock?) {
        let params = ["bundle_id": app.bundleId]
        makeAPICall(endPoint: .ratings, params: params, completionBlock: completionBlock)
    }

    class func postResponse(reviewId: String, bundleId: String, response: String, completionBlock: CompletionBlock?) {
        let params = ["rating_id": reviewId, "bundle_id": bundleId, "response_text": response]
        makeAPICall(endPoint: .response, params: params, httpMethod: .POST, completionBlock: completionBlock)
    }

    private class func makeAPICall(endPoint: EndPoint, params: [String: String] = [:], httpMethod: HTTPMethod = .GET, completionBlock: CompletionBlock?) {
        var url = BaseURL + endPoint.rawValue
        url += "?" + convertToUrlParameter(params)
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = httpMethod.rawValue
        URLSession.shared.dataTask(with: request) { d, r, e in
            if let d = d {
                do {
                    let json = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments)
                    completionBlock?(json, nil)
                } catch {
                    completionBlock?(nil, error)
                }
            } else {
                completionBlock?(nil, e)
            }
        }.resume()
    }

    private class func convertToUrlParameter(_ dict: [String: String]?) -> String {
        var parameterString: String = ""
        var i: Int = 0
        if let dict = dict {
            for (key, value) in dict {
                if i > 0 && i < dict.count {
                    parameterString += "&"
                }
                parameterString += "\(key)=\(value)"
                i += 1
            }
        }
        return parameterString
    }
}
