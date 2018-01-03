//
//  Meta.swift
//  ReviewMonitor
//
//  Created by Eliott Hauteclair on 3/01/18.
//  Copyright © 2018 Tayal, Rishabh. All rights reserved.
//

import UIKit

class Meta: NSObject {
    var name = String()
    var version = String()
    var copyright = String()
    var status = String()
    var languages = String()
    var keywords = String()
    var support = String()
    var marketing = String()
    var available = String()
    var watchos = String()
    var beta = String()
    var bundleID = String()
    var primaryCateg = String()
    var primaryCategSub1 = String()
    var primaryCategSub2 = String()
    var secondaryCateg = String()
    var secondaryCategSub1 = String()
    var secondaryCategSub2 = String()

    func set(_ name: String, version: String, copyright: String, status: String, languages: String, keywords: String, support: String, marketing: String, available: String, watchos: String, beta: String, bundleId: String, primaryCateg: String, primaryCategSub1: String, primaryCategSub2: String, secondaryCateg: String, secondaryCategSub1: String, secondaryCategSub2: String) {
        self.name = name
        self.version = version
        self.copyright = copyright
        self.status = status
        self.languages = languages
        self.keywords = keywords
        self.support = support
        self.marketing = marketing
        self.available = available
        self.watchos = watchos
        self.beta = beta
        bundleID = bundleId
        self.primaryCateg = primaryCateg
        self.primaryCategSub1 = primaryCategSub1
        self.primaryCategSub2 = primaryCategSub2
        self.secondaryCateg = secondaryCateg
        self.secondaryCategSub1 = secondaryCategSub1
        self.secondaryCategSub2 = secondaryCategSub2
    }
}
