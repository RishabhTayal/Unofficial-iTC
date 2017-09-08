//
//  Review.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/7/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit

class Review: NSObject {
    var review: String = ""
    
    init(dict: [String: Any]) {
        self.review = dict["review"] as! String
    }
}
