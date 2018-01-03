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
    @IBOutlet weak var statusLabel: UILabel!

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
        statusLabel.text = ""

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "View in App Store", style: .plain, target: self, action: #selector(viewInAppStoreTapped))

        getProcessingBuilds()
        getAppStatus()
    }

    @objc func viewInAppStoreTapped() {
        let url = URL(string: "https://itunes.apple.com/us/app/app/" + app.appId)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    private func getProcessingBuilds() {
        ServiceCaller.getProcessingBuilds(bundleId: app.bundleId) { result, e in
            DispatchQueue.main.async {
                if let r = result as? [[String: Any]] {
                    self.processingBuildCount = r.count
                    self.tableView.reloadData()
                }
            }
        }
    }

    private func getAppStatus() {
        ServiceCaller.getAppStatus(bundleId: app.bundleId) { result, e in
            DispatchQueue.main.async {
                guard let r = result as? [String: Any] else { return }
                self.statusLabel.text = r["app_status"] as? String
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
