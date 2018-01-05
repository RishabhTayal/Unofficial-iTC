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

    public class func createOfflineView() {
        let screenw = UIScreen.main.bounds.width - 200
        offlineView.frame = CGRect(x: screenw / 2, y: 35, width: 200, height: 48)
        let window = UIApplication.shared.keyWindow
        window?.addSubview(offlineView)
    }

    public class func removeOfflineView() {
        offlineView.removeFromSuperview()
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
