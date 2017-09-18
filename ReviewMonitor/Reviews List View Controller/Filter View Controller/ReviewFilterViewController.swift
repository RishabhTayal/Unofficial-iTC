//
//  ReviewFilterViewController.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/17/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit

protocol ReviewFilterViewControllerDelegate: class {
    func reviewFilterDidSelectFilter(filter: ReviewFilter)
}

class ReviewFilterViewController: UIViewController {

    var filter: ReviewFilter?

    weak var delegate: ReviewFilterViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Apply", style: .plain, target: self, action: #selector(applyTapped(_:)))
    }

    func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func applyTapped(_ sender: Any) {
        delegate?.reviewFilterDidSelectFilter(filter: filter!)
        dismiss(animated: true, completion: nil)
    }
}
