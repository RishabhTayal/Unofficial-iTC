//
//  LoginViewController.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/8/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
    }

    func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func signinTapped(_ sender: Any) {
        ServiceCaller.login { r, e in
            //            print(r)
            DispatchQueue.main.async {

                let account = Account(username: self.userNameTextField.text!, password: self.passwordTextField.text!)
                KeychainManger.storeAccount(account: account)

                if self.presentingViewController != nil {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.showAppView()
                }
            }
        }
        //        AppDelegate.currentUsername = userNameTextField.text
        //        AppDelegate.currentPassword = passwordTextField.text
        //        if presentingViewController != nil {
        //            dismiss(animated: true, completion: nil)
        //        } else {
        //            let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //            appDelegate.showAppView()
        //        }
    }
}
