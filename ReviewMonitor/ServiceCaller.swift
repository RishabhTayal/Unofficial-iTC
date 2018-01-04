//
//  ServiceCaller.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/7/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit

class ServiceCaller: NSObject {

    static func getBaseUrl() -> String {
        if let url = UserDefaults.standard.string(forKey: "baseURL") {
            return url
        }
        return ""
    }

    /// Saves server base url in user defaults. It also verifies if the specified url is the [itc hosted server](https://github.com/RishabhTayal/itc-api) url.
    ///
    /// - Parameter url: base url of the hosted server.
    /// - Returns: return `true` if the server is itc hosted server.
    static func setBaseUrlAndValidate(url: String) -> Bool {
        var url = url
        if url.last != "/" {
            url = url + "/"
        }
        do {
            let data = try Data(contentsOf: URL(string: url)!)
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
            if let _ = json["itc_api"] {
                UserDefaults.standard.set(url, forKey: "baseURL")
                UserDefaults.standard.synchronize()
                return true
            }
        } catch {}

        return false
    }

    private enum EndPoint: String {
        case login = "login/v2"
        case apps
        case ratings
        case response
        case testers
        case processing_builds
        case meta = "app/metadata"
    }

    private enum HTTPMethod: String {
        case GET
        case POST
        case Delete
    }

    typealias CompletionBlock = ((_ result: Any?, _ error: Error?) -> Void)

    class func askForBaseURL(controller: UIViewController) {
        let alert = UIAlertController(title: "Enter server url", message: "This is the url of your hosted server on Heroku. If you haven't done it yet, you need to host your server first. You can do so by clicking \"Haven't deployed yet\"", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            let tf = alert.textFields?.first
            let isValid = ServiceCaller.setBaseUrlAndValidate(url: (tf?.text)!)
            if !isValid {
                let errorAlert = UIAlertController(title: "These are not the droid you're looking for 🤖", message: "The hosted server url you provided is not the correct url. Please enter again", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    askForBaseURL(controller: controller)
                }))
                controller.present(errorAlert, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Haven't deployed yet.", style: .default, handler: { action in
            if UIApplication.shared.canOpenURL(URL(string: "https://heroku.com/deploy?template=https://github.com/RishabhTayal/itc-api/tree/master")!) {
                UIApplication.shared.open(URL(string: "https://heroku.com/deploy?template=https://github.com/RishabhTayal/itc-api/tree/master")!, options: [:], completionHandler: nil)
            }
        }))
        alert.addTextField(configurationHandler: { tf in
            tf.text = ServiceCaller.getBaseUrl()
        })
        controller.present(alert, animated: true, completion: nil)
    }

    class func login(username: String, password: String, completion: CompletionBlock?) {
        let header = ["username": username, "password": password]
        makeAPICall(endPoint: .login, httpMethod: .POST, header: header, completionBlock: completion)
    }

    class func getApps(completionBlock: CompletionBlock?) {
        makeAPICall(endPoint: .apps, completionBlock: completionBlock)
    }

    class func getAppMetadata(bundleId: String, completionBlock: CompletionBlock?) {
        let param = ["bundle_id": bundleId]
        makeAPICall(endPoint: .meta, params: param, completionBlock: completionBlock)
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

    private class func makeAPICall(endPoint: EndPoint, params: [String: Any] = [:], httpMethod: HTTPMethod = .GET, header: [String: String] = [:], completionBlock: CompletionBlock?) {

        var url = getBaseUrl() + endPoint.rawValue
        url += "?" + convertToUrlParameter(params)
        url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

        var request = URLRequest(url: URL(string: url)!)
        if let account = AccountManger.getCurrentAccount() {
            request.setValue(account.password, forHTTPHeaderField: "password")
            request.setValue(account.teamId.stringValue, forHTTPHeaderField: "team_id")
            request.setValue(account.username, forHTTPHeaderField: "username")
        }
        for key in header.keys {
            request.setValue(header[key]!, forHTTPHeaderField: key)
        }
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
