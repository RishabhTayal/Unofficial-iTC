//
//  Offline.swift
//  ReviewMonitor
//
//  Created by Eliott Hauteclair on 4/01/18.
//  Copyright © 2018 Tayal, Rishabh. All rights reserved.
//

import UIKit

class Offline: UIView {

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Offline", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
}
