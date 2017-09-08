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

    init(dict: [String: Any]) {
        name = dict["name"] as! String
        previewUrl = dict["app_icon_preview_url"] as? String
    }
}
