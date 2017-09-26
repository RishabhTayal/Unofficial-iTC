//
//  Tester.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/25/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit

// iTunes connect tester object
class Tester: NSObject {
    var firstName: String
    var lastName: String
    var email: String

    init(dict: [String: Any]) {
        firstName = dict["first_name"] as! String
        lastName = dict["last_name"] as! String
        email = dict["email"] as! String
    }
}
