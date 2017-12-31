//
//  ResponseEditorViewController.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/13/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit
import MBProgressHUD

class ResponseEditorViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    var review: Review?
    var app: App?

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = review?.developerResponse?.response
        textView.becomeFirstResponder()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(postTapped))
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    @objc func postTapped() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        MBProgressHUD.showAdded(to: view, animated: true)
        ServiceCaller.postResponse(reviewId: (review?.id)!, bundleId: (app?.bundleId)!, response: textView.text) { r, e in
            DispatchQueue.main.async {
                if r != nil {
                    self.navigationController?.popViewController(animated: true)
                } else {
                }
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
}
