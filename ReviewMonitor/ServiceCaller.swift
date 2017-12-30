//
//  ServiceCaller.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/7/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit

class ServiceCaller: NSObject {

    private static let BaseUrl: String = {
        /*#if DEBUG
            return "http://127.0.0.1:4567/"
        #else
            return "https://review-monitor.herokuapp.com/"
        #endif*/
        "https://review-monitor.herokuapp.com/"
    }()

    private enum EndPoint: String {
        case login = "login/v2"
        case apps
        case ratings
        case response
        case testers
        case processing_builds
    }

    private enum HTTPMethod: String {
        case GET
        case POST
        case Delete
    }

    typealias CompletionBlock = ((_ result: Any?, _ error: Error?) -> Void)

    class func login(username: String, password: String, completion: CompletionBlock?) {
        let params = ["username": username, "password": password]
        makeAPICall(endPoint: .login, params: params, httpMethod: .POST, completionBlock: completion)
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

    class func deleteResponse(reviewId: NSNumber, bundleId: String, responseId: NSNumber, completionBlock: CompletionBlock?) {
        let params = ["rating_id": reviewId, "bundle_id": bundleId, "response_id": responseId] as [String: Any]
        makeAPICall(endPoint: .response, params: params, httpMethod: .Delete, completionBlock: completionBlock)
    }

    class func getTesters(bundleId: String, completion: CompletionBlock?) {
        let params = ["bundle_id": bundleId]
        makeAPICall(endPoint: .testers, params: params, completionBlock: completion)
    }

    class func getProcessingBuilds(bundleId: String, completion: CompletionBlock?) {
        let params = ["bundle_id": bundleId]
        makeAPICall(endPoint: .processing_builds, params: params, completionBlock: completion)
    }

    private class func makeAPICall(endPoint: EndPoint, params: [String: Any] = [:], httpMethod: HTTPMethod = .GET, completionBlock: CompletionBlock?) {
        var params = params
        var url = BaseUrl + endPoint.rawValue
        if let account = AccountManger.getCurrentAccount() {
            params.updateValue(account.username, forKey: "username")
            params["password"] = account.password
            params["team_id"] = account.teamId
        }
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
