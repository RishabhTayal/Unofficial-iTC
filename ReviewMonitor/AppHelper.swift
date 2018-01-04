//
//  AppHelper.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 1/3/18.
//  Copyright © 2018 Tayal, Rishabh. All rights reserved.
//

import UIKit

enum DateFormat: String {
    case MMMddyyy = "MMM dd, yyyy"
}

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

extension Date {
    func formatDate(format: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
}

extension String {
    mutating func replace(_ originalString: String, with newString: String) {
        self = replacingOccurrences(of: originalString, with: newString)
    }
}
