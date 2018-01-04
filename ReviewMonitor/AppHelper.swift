//
//  AppHelper.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 1/3/18.
//  Copyright © 2018 Tayal, Rishabh. All rights reserved.
//

import UIKit

import SystemConfiguration

enum DateFormat: String {
    case MMMddyyy = "MMM dd, yyyy"
}

class ReachabilityManager: NSObject {
    static let offline = Offline.instanceFromNib()

    public class func createOfflineView() {
        let screenw = UIScreen.main.bounds.width - 200
        offline.frame = CGRect(x: screenw / 2, y: 35, width: 200, height: 48)
        let window = UIApplication.shared.keyWindow
        window?.addSubview(offline)
    }

    public class func removeOfflineView() {
        offline.removeFromSuperview()
    }

    static let shared = ReachabilityManager()
    var isNetworkAvailable: Bool {
        return reachabilityStatus != .none
    }

    let reachability = Reachability()!
    var reachabilityStatus: Reachability.Connection = .none

    @objc func reachabilityChanged(_ notification: Notification) {
        let reachability = notification.object as! Reachability
        switch reachability.connection {
        case .none:
            ReachabilityManager.createOfflineView()
        case .wifi, .cellular:
            ReachabilityManager.removeOfflineView()
        }
    }

    func startMonitoring() {

        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: Notification.Name.reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
        }
    }

    func stopMonitoring() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged,
                                                  object: reachability)
    }
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

    class func loadFromNibNamed(nibNamed: String, bundle: Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
        ).instantiate(withOwner: nil, options: nil)[0] as? UIView
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
