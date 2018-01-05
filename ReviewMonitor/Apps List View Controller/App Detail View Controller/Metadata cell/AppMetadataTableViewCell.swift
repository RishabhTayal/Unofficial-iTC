//
//  AppMetadataTableViewCell.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 1/5/18.
//  Copyright © 2018 Tayal, Rishabh. All rights reserved.
//

import UIKit

class AppMetadataTableViewCell: UITableViewCell {

    @IBOutlet weak var primaryCategoryLabel: UILabel!
    @IBOutlet weak var secondaryCategoryLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureView(metadata: AppMetadata) {
        primaryCategoryLabel.text = metadata.primaryCateg
        secondaryCategoryLabel.text = metadata.secondaryCateg
    }
}
