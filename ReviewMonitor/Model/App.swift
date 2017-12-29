//
//  App.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/7/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit

class App: NSObject {
    var name: String = ""
    var previewUrl: String? = ""
    var bundleId: String = ""
    var platforms: [String] = []

    init(dict: [String: Any]) {
        name = dict["name"] as! String
        bundleId = dict["bundle_id"] as! String
        previewUrl = dict["app_icon_preview_url"] as? String
        platforms = dict["platforms"] as! [String]
    }
}
