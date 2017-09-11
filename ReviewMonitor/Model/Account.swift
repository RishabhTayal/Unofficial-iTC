//
//  Account.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/9/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit

class Account: NSObject, NSCoding {

    var isCurrentAccount = false
    var username: String = ""
    var password: String = ""

    init(username: String, password: String, isCurrentAccount: Bool) {
        self.username = username
        self.password = password
        self.isCurrentAccount = isCurrentAccount
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: "username")
        aCoder.encode(password, forKey: "password")
        aCoder.encode(isCurrentAccount, forKey: "isCurrentAccount")
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let username = aDecoder.decodeObject(forKey: "username")
        let password = aDecoder.decodeObject(forKey: "password")
        let isCurrentAccount = aDecoder.decodeBool(forKey: "isCurrentAccount")
        self.init(username: username as! String, password: password as! String, isCurrentAccount: isCurrentAccount)
    }
}
