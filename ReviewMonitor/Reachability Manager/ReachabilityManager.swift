//
//  ReachabilityManager.swift
//  ReviewMonitor
//
//  Created by Eliott Hauteclair on 5/01/18.
//  Copyright © 2018 Tayal, Rishabh. All rights reserved.
//

import UIKit

class ReachabilityManager: NSObject {

    static let offlineView = UIView.loadFromNibNamed(nibNamed: "OfflineView")!
    let reachability = Reachability()!
    var reachabilityStatus: Reachability.Connection = .none
    static var tap = UITapGestureRecognizer()
    static let screenw = UIScreen.main.bounds.width - 200

    public class func createOfflineView() {
        offlineView.frame = CGRect(x: screenw / 2, y: -55, width: 200, height: 48)
        let window = UIApplication.shared.keyWindow
        window?.addSubview(offlineView)
        UIView.animate(withDuration: 0.75, animations: {
            offlineView.frame = CGRect(x: screenw / 2, y: 35, width: 200, height: 48)
        }, completion: nil)
        perform(#selector(removeOfflineView), with: nil, afterDelay: 5)
        tap = UITapGestureRecognizer(target: self, action: #selector(removeOfflineView))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        offlineView.addGestureRecognizer(tap)
    }

    @objc public class func removeOfflineView() {
        UIView.animate(withDuration: 0.75, animations: {
            offlineView.frame = CGRect(x: screenw / 2, y: -55, width: 200, height: 48)
        }, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            offlineView.removeFromSuperview()
            offlineView.removeGestureRecognizer(tap)
        }
    }

    static let shared = ReachabilityManager()
    var isNetworkAvailable: Bool {
        return reachabilityStatus != .none
    }

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
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
        }
    }

    func stopMonitoring() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: reachability)
    }
}
