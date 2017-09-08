//
//  ReviewsListTableViewCell.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/8/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit
import HCSStarRatingView

class ReviewsListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var territoryImageView: UIImageView!
    @IBOutlet weak var devResponseFlagLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func config(review: Review) {
        titleLabel.text = review.title
        authorLabel.text = review.storeFront
        reviewLabel.text = review.review
        ratingView.value = review.rating as! CGFloat
        if review.rawDeveloperResponse is NSNull {
            devResponseFlagLabel.text = ""
        } else {
            devResponseFlagLabel.text = "Responded"
        }
    }
}
