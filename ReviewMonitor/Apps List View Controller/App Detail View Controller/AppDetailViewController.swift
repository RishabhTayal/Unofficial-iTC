//
//  AppDetailViewController.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/26/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit

class AppDetailViewController: UIViewController {

    enum SectionType: Int {
        case appStore
        case testflight

        static var numberOfSections = 2
    }

    struct Rows {
        static var appstore = ["Reviews"]
        static var testflight = ["Testers"]
    }

    @IBOutlet var tableView: UITableView!
    @IBOutlet var appImageView: UIImageView!
    @IBOutlet var appNameLabel: UILabel!
    @IBOutlet var platformLabel: UILabel!

    var app: App!
    var processingBuildCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        title = app.name

        appImageView.addBorder(1 / UIScreen.main.scale, color: UIColor.lightGray)
        appImageView.cornerRadius(8)
        if let imageUrl = app.previewUrl {
            appImageView.sd_setImage(with: URL(string: imageUrl)!, completed: nil)
        } else {
            appImageView.image = UIImage(named: "empty_app_icon")
        }
        appNameLabel.text = app.name
        platformLabel.text = app.platforms.joined(separator: ", ")

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "View in App Store", style: .plain, target: self, action: #selector(viewInAppStoreTapped))
        // getProcessingBuilds()
        metaData()
    }

    @IBOutlet weak var textBack: UITextView!
    var phrases = ["Version: %@\n", "Copyright: %@\n", "Status: %@\n", "%@ on store\n", "Primary Category: %@\n", "     Sub Category: %@\n", "     Second Sub Category: %@\n", "Languages: %@\n", "%@ on  Watch."]
    var langs = Array<Any>()
    func metaData() {
        textBack.isEditable = false
        textBack.isSelectable = false

        ServiceCaller.getMeta(bundleId: app.bundleId) { result, error in
            // print(result)
            if let r = result as? Dictionary<String, Any> {

                guard let ver = r["version"] as? String else {
                    return self.phrases[0] = ""
                }

                guard let copyright = r["copyright"] as? String else {
                    return self.phrases[1] = ""
                }

                guard let status = r["status"] as? String else {
                    return self.phrases[2] = ""
                }

                let lang = r["lang"] as! Array<Dictionary<String, Any>>

                for x in 0 ..< lang.count {
                    let l = lang[x]["language"] as! String

                    self.langs.append(l)
                }

                let avail = (r["islive"] as? Bool)! ? "Available" : "Not Available"
                let watchos = (r["watchos"] as? Bool)! ? "Runs" : "Doesn't run"
                let beta = (r["betaTesting"] as? Bool)! ? "Beta Testing Enabled\n" : "No Beta Testing\n"


                /*                 guard let primarycat = self.meta[0].primaryCategory else {
                 return self.phrases[4] = ""
                 }
                 if primarycat.contains("MZGenre.") {
                 primarycat.dropFirst(8)
                 }
                 guard let primarySubcat = self.meta[0].primarySubCategory else {
                 return self.phrases[5] = ""
                 }
                 if primarySubcat.contains("MZGenre.") {
                 primarySubcat.dropFirst(8)
                 }
                 guard let primarySecSubcat = self.meta[0].primarySecSubCategory else {
                 return self.phrases[6] = ""
                 }
                 if primarySecSubcat.contains("MZGenre.") {
                 primarySecSubcat.dropFirst(8)
                 } */

                DispatchQueue.main.async {
                    let lng = self.langs
                        .map { String(describing: $0) }
                        .joined(separator: ", ")
                    
                    self.textBack.text = "\(String(format: self.phrases[0], ver))\(String(format: self.phrases[1], copyright))\(String(format: self.phrases[2], status))\(String(format: self.phrases[3], avail))\(String(format: self.phrases[7], String(describing: lng)))\(String(format: self.phrases[8], watchos))\(beta)"
                }
                // \(String(format: self.phrases[3], avail))\(String(format: self.phrases[4], primarycat))\(String(format: self.phrases[5], primarySubcat))\(String(format: self.phrases[6], primarySecSubcat))
            }
        }
    }

    @objc func viewInAppStoreTapped() {
        let url = URL(string: "https://itunes.apple.com/us/app/app/" + app.appId)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    func getProcessingBuilds() {
        ServiceCaller.getProcessingBuilds(bundleId: app.bundleId) { result, e in
            DispatchQueue.main.async {
                if let r = result as? [[String: Any]] {
                    self.processingBuildCount = r.count
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension AppDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SectionType.appStore.rawValue {
            return Rows.appstore.count
        }
        return Rows.testflight.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == SectionType.appStore.rawValue {
            return "App Store"
        }
        return "TestFlight"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell?.accessoryType = .disclosureIndicator
        }
        if indexPath.section == SectionType.appStore.rawValue {
            cell?.textLabel?.text = Rows.appstore[indexPath.row]
        } else if indexPath.section == SectionType.testflight.rawValue {
            cell?.textLabel?.text = Rows.testflight[indexPath.row]
        } else {
        }

        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SectionType.appStore.rawValue {
            let reviewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReviewsViewController") as! ReviewsViewController
            reviewVC.app = app
            navigationController?.pushViewController(reviewVC, animated: true)
        } else if indexPath.section == SectionType.testflight.rawValue {
            let testersVC = TestersViewController()
            testersVC.app = app
            navigationController?.pushViewController(testersVC, animated: true)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
