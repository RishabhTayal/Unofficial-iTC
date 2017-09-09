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
        case login
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

    class func login(completion: CompletionBlock?) {
        makeAPICall(endPoint: .login, httpMethod: .POST, completionBlock: completion)
    }

    class func getApps(completionBlock: CompletionBlock?) {
        makeAPICall(endPoint: .apps, completionBlock: completionBlock)
    }

    class func getReviews(app: App, storeFront: String = "", completionBlock: CompletionBlock?) {
        let params = ["bundle_id": app.bundleId, "store_front": storeFront]
        makeAPICall(endPoint: .ratings, params: params, completionBlock: completionBlock)
    }

    class func postResponse(reviewId: NSNumber, bundleId: String, response: String, completionBlock: CompletionBlock?) {
        let params = ["rating_id": reviewId, "bundle_id": bundleId, "response_text": response] as [String: Any]
        makeAPICall(endPoint: .response, params: params, httpMethod: .POST, completionBlock: completionBlock)
    }

    private class func makeAPICall(endPoint: EndPoint, params: [String: Any] = [:], httpMethod: HTTPMethod = .GET, completionBlock: CompletionBlock?) {
        var params = params
        var url = BaseURL + endPoint.rawValue
        //        params.updateValue(AppDelegate.currentUsername ?? "", forKey: "username")
        //        params["password"] = AppDelegate.currentPassword
        url += "?" + convertToUrlParameter(params)
        url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
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

    private class func convertToUrlParameter(_ dict: [String: Any]?) -> String {
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
