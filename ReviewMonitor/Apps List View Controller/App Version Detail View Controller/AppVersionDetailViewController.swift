//
//  AppVersionDetailViewController.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 1/5/18.
//  Copyright © 2018 Tayal, Rishabh. All rights reserved.
//

import UIKit
import SDWebImage

class AppVersionDetailViewController: UIViewController {

    var app: App?
    var appMetadata: AppMetadata?

    var appVersionMetadata: AppVersion?

    @IBOutlet weak var versionSegmentControl: UISegmentedControl!
    @IBOutlet var imageView: UIImageView!

    init() {
        super.init(nibName: "AppVersionDetailViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var segments: [String] = []
        if appMetadata?.liveVersion != nil {
            getLiveVersion()
            segments.append((appMetadata?.liveVersion)!)
        } else if appMetadata?.editVersion != nil {
            // Get edit version details
            getEditVersion()
            segments.append((appMetadata?.editVersion)!)
        }
        versionSegmentControl.removeAllSegments()
        if segments.count > 1 {
            for (i, item) in segments.enumerated() {
                versionSegmentControl.insertSegment(withTitle: item, at: i, animated: true)
            }
        }
    }

    func getLiveVersion() {
        ServiceCaller.getAppLiveVersionMetadata(bundleId: (app?.bundleId)!) { result, error in
            if let result = result as? [String: Any] {
                print(result)
                self.appVersionMetadata = AppVersion(dict: result)
                DispatchQueue.main.async {
                    self.imageView.sd_setImage(with: URL(string: (self.appVersionMetadata?.screenshots.first?.url)!), completed: nil)
                }
            }
        }
    }

    func getEditVersion() {
        ServiceCaller.getAppEditVersionMetadata(bundleId: (app?.bundleId)!) { result, error in
            if let result = result as? [String: Any] {
                print(result)
                self.appVersionMetadata = AppVersion(dict: result)
            }
        }
    }

    @IBAction func versionSegmentControlChanged(_ sender: UISegmentedControl) {
    }
}
