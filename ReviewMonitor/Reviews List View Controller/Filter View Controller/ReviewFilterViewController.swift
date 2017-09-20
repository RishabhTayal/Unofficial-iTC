//
//  ReviewFilterViewController.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/17/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit
import TTRangeSlider

protocol ReviewFilterViewControllerDelegate: class {
    func reviewFilterDidSelectFilter(filter: ReviewFilter)
}

class ReviewFilterViewController: UIViewController {

    @IBOutlet weak var slider: TTRangeSlider!
    @IBOutlet weak var respondedSwitch: UISwitch!

    var filter: ReviewFilter!

    weak var delegate: ReviewFilterViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        if filter == nil {
            filter = ReviewFilter()
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Apply", style: .plain, target: self, action: #selector(applyTapped(_:)))

        setupViewWithFilter()
    }

    func setupViewWithFilter() {
        if let filter = filter {
            slider.selectedMinimum = filter.minRating
            slider.selectedMaximum = filter.maxRating
            respondedSwitch.isOn = filter.developerResponded
        }
    }

    @objc func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @objc func applyTapped(_ sender: Any) {
        delegate?.reviewFilterDidSelectFilter(filter: filter)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func ratingChanged(_ sender: TTRangeSlider) {
        filter.minRating = sender.minValue
        filter.maxRating = sender.maxValue
    }

    @IBAction func respondedSwitchToggled(_ sender: UISwitch) {
        filter.developerResponded = sender.isOn
    }
}

extension ReviewFilterViewController: TTRangeSliderDelegate {
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        filter.minRating = selectedMinimum
        filter.maxRating = selectedMaximum
    }
}
