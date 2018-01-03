//
//  AppHelper.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 1/3/18.
//  Copyright © 2018 Tayal, Rishabh. All rights reserved.
//

import UIKit

extension UIView {
    public func addBorder(_ width: CGFloat, color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    public func cornerRadius(_ radius: CGFloat) {
        layoutIfNeeded()
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}
