//
//  Review.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/7/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit

class Review: NSObject {

    var id: NSNumber
    var title: String = ""
    var lastModified: NSNumber = 0
    var review: String? = ""
    var rating: NSNumber? = 5
    var storeFront: String? = ""
    var developerResponse: DeveloperResponse?
    var rawDeveloperResponse: Any?

    init(dict: [String: Any]) {
        id = dict["id"] as! NSNumber
        title = dict["title"] as! String
        lastModified = dict["last_modified"] as! NSNumber
        review = dict["review"] as? String
        rating = dict["rating"] as? NSNumber
        storeFront = dict["store_front"] as? String
        developerResponse = DeveloperResponse(dict: dict["developer_response"] as! [String: Any])
        rawDeveloperResponse = dict["raw_developer_response"]
    }
}
