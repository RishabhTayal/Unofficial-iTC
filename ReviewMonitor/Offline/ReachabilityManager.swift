//
//  ReachabilityManager.swift
//  ReviewMonitor
//
//  Created by Eliott Hauteclair on 5/01/18.
//  Copyright © 2018 Tayal, Rishabh. All rights reserved.
//

import UIKit

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
