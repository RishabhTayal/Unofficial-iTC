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

    class func removeAccount(account: Account) {
        var accounts = getAccountArray()
        var index = 0
        accounts.forEach { a in
            if account.username == a.username {
                if let i = accounts.index(of: a) {
                    index = i
                }
            }
        }
        accounts.remove(at: index)
        clearAccounts()
        accounts.forEach { a in
            storeAccount(account: a)
        }
    }

    class func clearAccounts() {
        UserDefaults.standard.removeObject(forKey: accountsKey)
        UserDefaults.standard.synchronize()
    }

    class func setCurrentAccount(account: Account) {
        let accounts = getAccountArray()
        clearAccounts()
        accounts.forEach { a in
            if account.username == a.username {
                a.isCurrentAccount = true
            } else {
                a.isCurrentAccount = false
            }
            storeAccount(account: a)
        }
    }

    class func getCurrentAccount() -> Account? {
        let accounts = getAccountArray()
        var currentAccount: Account?
        accounts.forEach { a in
            if a.isCurrentAccount {
                currentAccount = a
            }
        }
        return currentAccount
    }
}
