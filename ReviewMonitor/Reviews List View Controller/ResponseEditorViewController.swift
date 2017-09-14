//
//  ResponseEditorViewController.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/13/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit

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

    func postTapped() {
        ServiceCaller.postResponse(reviewId: (review?.id)!, bundleId: (app?.bundleId)!, response: textView.text) { r, e in
            DispatchQueue.main.async {
                if r != nil {
                    self.navigationController?.popViewController(animated: true)
                } else {
                }
            }
        }
    }
}
