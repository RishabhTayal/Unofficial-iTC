//
//  KeychainManger.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/9/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit

class KeychainManger: NSObject {

    private static let accountsKey = "Accounts"
    class func getAccountArray() -> [Account] {
        guard let data = UserDefaults.standard.data(forKey: accountsKey) else {
            return []
        }
        guard let accounts = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Account] else {
            return []
        }
        return accounts
    }

    class func storeAccount(account: Account) {
        var accounts = getAccountArray()
        accounts.append(account)
        let data = NSKeyedArchiver.archivedData(withRootObject: accounts)
        UserDefaults.standard.set(data, forKey: accountsKey)
        UserDefaults.standard.synchronize()
    }
}
