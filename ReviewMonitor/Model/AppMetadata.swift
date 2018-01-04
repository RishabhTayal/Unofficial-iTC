//
//  Meta.swift
//  ReviewMonitor
//
//  Created by Eliott Hauteclair on 3/01/18.
//  Copyright © 2018 Tayal, Rishabh. All rights reserved.
//

import UIKit

class AppMetadata: NSObject {
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

    override init() {
    }

    init(name: String, bundleId: String, dict: [String: Any]) {
        self.name = name
        version = dict["version"] as? String ?? "-"
        copyright = dict["copyright"] as? String ?? "-"
        status = dict["status"] as? String ?? "-"

        let lang = dict["lang"] as! Array<Dictionary<String, Any>>
        for x in 0 ..< lang.count {
            let l = lang[x]["language"] as! String
            languages.append(l)
        }
        languages
            .map { String(describing: $0) }
            .joined(separator: ", ")
        keywords = dict["keywords"] as? String ?? "-"
        support = dict["support"] as? String ?? "-"
        marketing = dict["marketing"] as? String ?? "-"
        available = (dict["islive"] as? Bool)! ? "Available" : "Not Available"
        watchos = (dict["watchos"] as? Bool)! ? "Yes" : "No"
        beta = (dict["betaTesting"] as? Bool)! ? "Beta Testing Enabled\n" : "No Beta Testing\n"
        bundleID = bundleId
        primaryCateg = dict["primarycat"] as? String ?? "-"
        primaryCateg.replace("MZGenre.", with: "")
        primaryCategSub1 = dict["primarycatfirstsub"] as? String ?? "-"
        primaryCategSub1.replace("MZGenre.", with: "")
        primaryCategSub2 = dict["primarycatsecondsub"] as? String ?? "-"
        primaryCategSub2.replace("MZGenre.", with: "")

        secondaryCateg = dict["secondarycat"] as? String ?? "-"
        secondaryCateg.replace("MZGenre.", with: "")
        secondaryCategSub1 = dict["secondarycatfirstsub"] as? String ?? "-"
        secondaryCategSub1.replace("MZGenre.", with: "")
        secondaryCategSub2 = dict["secondarycatsecondsub"] as? String ?? "-"
        secondaryCategSub2.replace("MZGenre.", with: "")
    }
}
