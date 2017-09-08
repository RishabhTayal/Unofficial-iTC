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
    
    init(dict: [String: Any]) {
        self.name = dict["name"] as! String
    }
}
