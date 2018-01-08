//
//  AppScreenshot.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 1/8/18.
//  Copyright © 2018 Tayal, Rishabh. All rights reserved.
//

import UIKit

class AppScreenshot: NSObject {

    var originalFileName: String = ""
    var url = ""

    init(dict: [String: Any]) {
        originalFileName = dict["original_file_name"] as! String
        url = dict["url"] as! String
    }
}
