//
//  ReviewsListTableViewCell.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/8/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit
import HCSStarRatingView
import FlagKit

class ReviewsListTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var territoryImageView: UIImageView!
    @IBOutlet weak var devResponseFlagLabel: UILabel!
    @IBOutlet weak var developerResponseLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.cornerRadius(4)
        containerView.backgroundColor = UIColor(white: 0.9, alpha: 1)
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    func config(review: Review) {
        titleLabel.text = review.title
        let date = Date(timeIntervalSince1970: review.lastModified.doubleValue / 1000)
        timeStampLabel.text = date.formatDate(format: .MMMddyyy)
        authorLabel.text = review.storeFront
        countryImageView.image = Flag(countryCode: review.storeFront!)?.originalImage
        reviewLabel.text = review.review
        ratingView.value = review.rating as! CGFloat
        if let response = review.developerResponse, response.response != nil {
            devResponseFlagLabel.text = response.state?.description
            developerResponseLabel.text = response.response
        } else {
            devResponseFlagLabel.text = ""
            developerResponseLabel.text = ""
        }
    }
}
