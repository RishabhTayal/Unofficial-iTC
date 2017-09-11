//
//  LoginViewController.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/8/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOnView))
        view.addGestureRecognizer(tap)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
    }

    func tappedOnView() {
        view.endEditing(true)
    }

    func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func signinTapped(_ sender: Any) {
        let account = Account(username: userNameTextField.text!, password: passwordTextField.text!, isCurrentAccount: true)
        AccountManger.storeAccount(account: account)
        AccountManger.setCurrentAccount(account: account)

        MBProgressHUD.showAdded(to: view, animated: true)
        ServiceCaller.login { r, e in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                if r != nil {

                    if self.presentingViewController != nil {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.showAppView()
                    }
                } else {
                    AccountManger.removeAccount(account: account)
                    let alert = UIAlertController(title: "Login error", message: "Could not login. Please check your username and password.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
