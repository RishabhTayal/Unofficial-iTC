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

    let keychainWrapper = KeychainWrapper()

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

                UserDefaults.standard.setValue(self.userNameTextField.text, forKey: "username")
                self.keychainWrapper.mySetObject(self.passwordTextField.text, forKey: kSecValueData)
                self.keychainWrapper.writeToKeychain()

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
