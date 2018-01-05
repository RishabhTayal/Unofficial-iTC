//
//  Meta.swift
//  ReviewMonitor
//
//  Created by Eliott Hauteclair on 3/01/18.
//  Copyright © 2018 Tayal, Rishabh. All rights reserved.
//

import UIKit

class AppMetadata: NSObject {

    var liveVersion: String?
    var editVersion: String?
    var primaryCateg = String()
    var primaryCategSub1 = String()
    var primaryCategSub2 = String()
    var secondaryCateg = String()
    var secondaryCategSub1 = String()
    var secondaryCategSub2 = String()

    override init() {
    }

    init(name: String, bundleId: String, dict: [String: Any]) {
        liveVersion = dict["live_version"] as? String
        editVersion = dict["edit_version"] as? String

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
