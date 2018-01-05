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
    var islive: String = ""
    var watchos: String = ""
    var betaTesting: String = ""
    var lang: String = ""
    var keywords: String = ""
    var support: String = ""
    var marketing: String = ""

    override init() {
    }

    init(dict: [String: Any]) {
    }
}
