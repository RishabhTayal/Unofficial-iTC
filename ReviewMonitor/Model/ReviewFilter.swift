//
//  ReviewFilter.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/17/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit

class ReviewFilter: NSObject {

    var minRating: Float = 0
    var maxRating: Float = 5
    var developerResponded = false

    override init() {
        super.init()
    }
}
