//
//  DeveloperResponse.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/8/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit

class DeveloperResponse: NSObject {
    var id: NSNumber?
    var response: String?
    var last_modified: NSNumber?
    var hidden: String?
    var state: String?

    init(dict: [String: Any]) {
        id = dict["id"] as? NSNumber
        response = dict["response"] as? String
        last_modified = dict["last_modified"] as? NSNumber
        hidden = dict["hidden"] as? String
        state = dict["state"] as? String
    }
}
