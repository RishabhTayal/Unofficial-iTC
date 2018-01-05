//
//  AppVersionDetailViewController.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 1/5/18.
//  Copyright © 2018 Tayal, Rishabh. All rights reserved.
//

import UIKit

class AppVersionDetailViewController: UIViewController {

    var app: App?
    var appMetadata: AppMetadata?

    init() {
        super.init(nibName: "AppVersionDetailViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        getLiveVersion()
    }

    func getLiveVersion() {
        ServiceCaller.getAppVersionMetadata(bundleId: (app?.bundleId)!) { result, error in
            if let result = result {
                print(result)
            }
        }
    }
}
