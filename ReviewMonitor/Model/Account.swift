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
    var teamId: NSNumber
    var teamName: String

    init(username: String, password: String, isCurrentAccount: Bool, teamId: NSNumber, teamName: String) {
        self.username = username
        self.password = password
        self.isCurrentAccount = isCurrentAccount
        self.teamId = teamId
        self.teamName = teamName
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: "username")
        aCoder.encode(password, forKey: "password")
        aCoder.encode(isCurrentAccount, forKey: "isCurrentAccount")
        aCoder.encode(teamId, forKey: "teamId")
        aCoder.encode(teamName, forKey: "teamName")
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let username = aDecoder.decodeObject(forKey: "username") as! String
        let password = aDecoder.decodeObject(forKey: "password") as! String
        let isCurrentAccount = aDecoder.decodeBool(forKey: "isCurrentAccount")
        let teamId = aDecoder.decodeObject(forKey: "teamId") as! NSNumber
        let teamName = aDecoder.decodeObject(forKey: "teamName") as! String
        self.init(username: username, password: password, isCurrentAccount: isCurrentAccount, teamId: teamId, teamName: teamName)
    }
}
