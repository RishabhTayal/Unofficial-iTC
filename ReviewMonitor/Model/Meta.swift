//
//  Meta.swift
//  ReviewMonitor
//
//  Created by Eliott Hauteclair on 1/1/18.
//  Copyright © 2018 Tayal, Rishabh. All rights reserved.
//

import UIKit

class Meta: NSObject {

    var version: String? = ""
    var copyright: String? = ""
    var status: String? = ""
    var live: Bool? = false

    var primaryCategory: String? = ""
    var primarySubCategory: String? = ""
    var primarySecSubCategory: String? = ""

    init(dict: [String: Any]) {
        version = dict["version"] as? String ?? "-"
        copyright = dict["copyright"] as? String ?? "-"
        status = dict["status"] as? String ?? "-"
        live = dict["live"] as? Bool ?? false

        primaryCategory = dict["prim_categ"] as? String ?? "-"
        primarySubCategory = dict["prim_sub_categ"] as? String ?? "-"
        primarySecSubCategory = dict["second_sub_categ"] as? String ?? "-"
    }
}
