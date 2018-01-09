//
//  App.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/7/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit

class App: NSObject, NSCoding {
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let bundleID = aDecoder.decodeObject(forKey: "bundleId") as? String ?? "-"
        let previewUrl = aDecoder.decodeObject(forKey: "previewUrl") as? String
        let appId = aDecoder.decodeObject(forKey: "appId") as? String ?? "-"
        let platforms = aDecoder.decodeObject(forKey: "platforms") as! [String]
        let lastModified = aDecoder.decodeObject(forKey: "lastModified") as! NSNumber

        let a = [
            "name": name,
            "app_icon_preview_url": previewUrl,
            "bundle_id": bundleID,
            "apple_id": appId,
            "platforms": platforms,
            "last_modified": lastModified,
        ] as [String: Any]

        self.init(dict: a)
    }

    var name: String = ""
    var previewUrl: String? = ""
    var bundleId: String = ""
    var appId: String = ""
    var platforms: [String] = []
    var lastModified: NSNumber = 0

    init(dict: [String: Any]) {
        name = dict["name"] as! String
        bundleId = dict["bundle_id"] as? String ?? "-"
        previewUrl = dict["app_icon_preview_url"] as? String
        platforms = dict["platforms"] as! [String]
        appId = dict["apple_id"] as? String ?? "-"
        lastModified = dict["last_modified"] as! NSNumber
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(previewUrl, forKey: "previewUrl")
        aCoder.encode(bundleId, forKey: "bundleId")
        aCoder.encode(appId, forKey: "appId")
        aCoder.encode(platforms, forKey: "platforms")
        aCoder.encode(lastModified, forKey: "lastModified")
    }
}
