//
//  AppVersionDetailViewController.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 1/5/18.
//  Copyright © 2018 Tayal, Rishabh. All rights reserved.
//

import UIKit

enum AppVersionType {
    case live
    case edit
    case other
}

class AppVersionDetailViewController: UIViewController {

    var appVersionType: AppVersionType = .other
    var app: App?
    var appMetadata: AppMetadata?

    var appVersionMetadata: AppVersion?

    init() {
        super.init(nibName: "AppVersionDetailViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if appVersionType == .live {
            getLiveVersion()
        } else if appVersionType == .edit {
            // Get edit version details
        }
    }

    func getLiveVersion() {
        ServiceCaller.getAppLiveVersionMetadata(bundleId: (app?.bundleId)!) { result, error in
            if let result = result as? [String: Any] {
                print(result)
                self.appVersionMetadata = AppVersion(dict: result)
            }
        }
    }

    func getEditVersion() {
        ServiceCaller.getAppEditVersionMetadata(bundleId: (app?.bundleId)!) { result, error in
            if let result = result {
                print(result)
                //                let
            }
        }
    }
}
