//
//  AddTesterViewController.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 1/9/18.
//  Copyright © 2018 Tayal, Rishabh. All rights reserved.
//

import UIKit
import MBProgressHUD

class AddTesterViewController: UIViewController {

    var app: App!

    @IBOutlet var firstNameTF: UITextField!
    @IBOutlet var lastNameTF: UITextField!
    @IBOutlet var emailTF: UITextField!

    init() {
        super.init(nibName: "AddTesterViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add new tester"

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped(_:)))
    }

    @objc func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @objc func saveTapped(_ sender: Any) {
        MBProgressHUD.showAdded(to: view, animated: true)
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem?.isEnabled = false
        ServiceCaller.addNewTester(bundleId: app.bundleId, firstName: firstNameTF.text!, lastName: lastNameTF.text!, email: emailTF.text!) { result, error in
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.navigationItem.leftBarButtonItem?.isEnabled = true
                MBProgressHUD.hide(for: self.view, animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
