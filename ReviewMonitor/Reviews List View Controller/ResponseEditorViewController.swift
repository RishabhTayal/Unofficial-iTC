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

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = review?.developerResponse?.response
        textView.becomeFirstResponder()
    }
}
