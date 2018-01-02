//
//  AccountsViewController.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/8/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit

protocol AccountsViewControllerDelegate: class {
    func accountsControllerDidDismiss()
}

class AccountsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var accounts: [Account] = []

    weak var delegate: AccountsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Accounts"

        tableView.tableFooterView = UIView()
        accounts = AccountManger.getAccountArray()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_close"), style: .plain, target: self, action: #selector(cancelTapped))
    }

    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension AccountsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        if indexPath.row >= accounts.count {
            cell?.textLabel?.text = "Add Account"
            cell?.textLabel?.textAlignment = .center
        } else {
            let account = accounts[indexPath.row]
            cell?.textLabel?.text = accounts[indexPath.row].teamName
            cell?.detailTextLabel?.text = accounts[indexPath.row].teamId.stringValue
            cell?.textLabel?.textAlignment = .left
            if account.isCurrentAccount {
                cell?.accessoryType = .checkmark
            } else {
                cell?.accessoryType = .none
            }
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row < accounts.count {
            AccountManger.setCurrentAccount(account: accounts[indexPath.row])
            delegate?.accountsControllerDidDismiss()
            cancelTapped()
        } else {
            let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
            loginVC.delegate = self
            present(UINavigationController(rootViewController: loginVC), animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row < accounts.count {
            return true
        }
        return false
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let account = accounts[indexPath.row]
        AccountManger.removeAccount(account: account)
        accounts.remove(at: indexPath.row)
        self.tableView.reloadData()
    }
}

extension AccountsViewController: LoginViewControllerDelegate {
    func loginControllerDidLogin() {
        accounts = AccountManger.getAccountArray()
        tableView.reloadData()
    }
}
