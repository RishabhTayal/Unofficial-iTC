//
//  AppVersion.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 1/5/18.
//  Copyright © 2018 Tayal, Rishabh. All rights reserved.
//

import UIKit

class AppVersion: NSObject {
    var isLiveVersion = false
    var isEditVersion = false

    var version: String = ""
    var copyright: String = ""
    var status: String = ""
    var islive: Bool = false
    var watchos: Bool = false
    var betaTesting: Bool = false
    var lang: String = ""
    var keywords: String = ""
    var support: String = ""
    var marketing: String = ""

    override init() {
    }

    init(dict: [String: Any]) {
        betaTesting = dict["betaTesting"] as! Bool
        copyright = dict["copyright"] as! String
        islive = dict["islive"] as! Bool
        keywords = dict["keywords"] as! String
        marketing = dict["marketing"] as! String
        status = dict["status"] as! String
        support = dict["support"] as! String
        version = dict["version"] as! String
        watchos = dict["watchos"] as! Bool
    }
}
