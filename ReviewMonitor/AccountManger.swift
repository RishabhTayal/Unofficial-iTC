//
//  KeychainManger.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/9/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit
import LocalAuthentication

class AccountManger: NSObject {

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
            if account.teamId == a.teamId {
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
            if account.teamId == a.teamId {
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

    func authenticateUser(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        // Get the current authentication context
        let context = LAContext()
        var error: NSError?
        let myLocalizedReasonString = "Authentification is required"

        // Check if the device is compatible with TouchID and can evaluate the policy.
        guard context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            DispatchQueue.main.async {
                failure(error!)
            }
            return
        }

        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: myLocalizedReasonString,
                               reply: { status, error in
                                   if status {
                                       DispatchQueue.main.async {
                                           success()
                                       }
                                   } else {
                                       DispatchQueue.main.async {
                                           failure(error!)
                                       }
                                   }
        })
    }
}
