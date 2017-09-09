//
//  AccountsViewController.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/8/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var accounts: [String] = ["a", "b"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
    }

    func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension AccountsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        if indexPath.row >= accounts.count {
            cell?.textLabel?.text = "Add Account"
            cell?.textLabel?.textAlignment = .center
        } else {
            cell?.textLabel?.text = "a"
            cell?.textLabel?.textAlignment = .left
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row < accounts.count {
            cancelTapped()
        } else {
            let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
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
        accounts.remove(at: indexPath.row)
        self.tableView.reloadData()
    }
}
