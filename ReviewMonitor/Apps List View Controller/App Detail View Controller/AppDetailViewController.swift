//
//  AppDetailViewController.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/26/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit

import Presentr

class AppDetailViewController: UIViewController {

    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .bottomHalf)
        presenter.transitionType = TransitionType.coverVertical
        presenter.dismissOnSwipe = true
        presenter.blurBackground = true
        return presenter
    }()

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

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var bundleLabel: UILabel!
    @IBOutlet weak var langLabel: UILabel!
    @IBOutlet weak var aw: UILabel!
    @IBOutlet weak var moreButton: UIButton!

    let meta = Meta()
    var langs = Array<Any>()
    func metaData() {
        ServiceCaller.getMeta(bundleId: app.bundleId) { result, error in
            // print(result)
            if let r = result as? Dictionary<String, Any> {

                let ver = r["version"] as? String ?? "-"
                let copyright = r["copyright"] as? String ?? "-"
                let status = r["status"] as? String ?? "-"
                let lang = r["lang"] as! Array<Dictionary<String, Any>>

                for x in 0 ..< lang.count {
                    let l = lang[x]["language"] as! String

                    self.langs.append(l)
                }

                let keyw = r["keywords"] as? String ?? "-"
                let supportUrl = r["support"] as? String ?? "-"
                let marketingUrl = r["marketing"] as? String ?? "-"
                let avail = (r["islive"] as? Bool)! ? "Available" : "Not Available"
                let watchos = (r["watchos"] as? Bool)! ? "Yes" : "No"
                let beta = (r["betaTesting"] as? Bool)! ? "Beta Testing Enabled\n" : "No Beta Testing\n"

                var primarycat = r["primarycat"] as? String ?? "-"
                primarycat.replace("MZGenre.", with: "")
                var primarySubcat = r["primarycatfirstsub"] as? String ?? "-"
                primarySubcat.replace("MZGenre.", with: "")
                var primarySubSeccat = r["primarycatsecondsub"] as? String ?? "-"
                primarySubSeccat.replace("MZGenre.", with: "")

                var secondarycat = r["secondarycat"] as? String ?? "-"
                secondarycat.replace("MZGenre.", with: "")
                var secondarySubcat = r["secondarycatfirstsub"] as? String ?? "-"
                secondarySubcat.replace("MZGenre.", with: "")
                var secondarySubSeccat = r["secondarycatsecondsub"] as? String ?? "-"
                secondarySubSeccat.replace("MZGenre.", with: "")

                DispatchQueue.main.async {
                    let lng = self.langs
                        .map { String(describing: $0) }
                        .joined(separator: ", ")

                    self.nameLabel.text = avail
                    self.versionLabel.text = ver
                    self.statusLabel.text = status
                    self.bundleLabel.text = self.app.bundleId
                    self.langLabel.text = lng
                    self.aw.text = watchos

                    self.meta.set(self.app.name, version: ver, copyright: copyright, status: status, languages: lng, keywords: keyw, support: supportUrl, marketing: marketingUrl, available: avail, watchos: watchos, beta: beta, bundleId: self.app.bundleId, primaryCateg: primarycat, primaryCategSub1: primarySubcat, primaryCategSub2: primarySubSeccat, secondaryCateg: secondarycat, secondaryCategSub1: secondarySubcat, secondaryCategSub2: secondarySubSeccat)

                    self.moreButton.addTarget(self, action: #selector(self.viewAllMeta), for: .touchUpInside)
                }
            }
        }
    }

    @objc func viewAllMeta() {
        let metaVC = MetaViewController(nibName: "MetaViewController", bundle: nil)
        metaVC.m = meta
        let navC = UINavigationController(rootViewController: metaVC)
        customPresentViewController(presenter, viewController: navC, animated: true, completion: nil)
    }

    @objc func viewInAppStoreTapped() {
        let url = URL(string: "https://itunes.apple.com/us/app/app/id" + app.appId)!
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

extension String {
    mutating func replace(_ originalString: String, with newString: String) {
        self = replacingOccurrences(of: originalString, with: newString)
    }
}
