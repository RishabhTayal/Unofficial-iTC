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
        let presenter = Presentr(presentationType: .dynamic(center: .bottomCenter))
        presenter.transitionType = TransitionType.coverVertical
        presenter.dismissOnSwipe = true
        presenter.blurBackground = true
        return presenter
    }()

    enum SectionType: Int {
        case appStore
        case testflight
        case metadata

        var description: String {
            switch self {
            case .appStore:
                return "App Store"
            case .testflight:
                return "TestFlight"
            case .metadata:
                return "App Information"
            }
        }

        static var numberOfSections = 3
    }

    struct Rows {
        static var appstore = ["iOS", "Reviews"]
        static var testflight = ["Testers"]
        static var metadata = [Any]()
    }

    @IBOutlet var tableView: UITableView!
    @IBOutlet var appImageView: UIImageView!
    @IBOutlet var appNameLabel: UILabel!
    @IBOutlet var platformLabel: UILabel!
    @IBOutlet var lastModifiedLabel: UILabel!

    var app: App!
    var metadata: AppMetadata?

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
        let date = Date(timeIntervalSince1970: app.lastModified.doubleValue / 1000)
        lastModifiedLabel.text = "Last modified: \(date.formatDate(format: .MMMddyyy))"

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "View in App Store", style: .plain, target: self, action: #selector(viewInAppStoreTapped))

        getMetaData()
    }

    func getMetaData() {
        ServiceCaller.getAppMetadata(bundleId: app.bundleId) { result, error in
            if let r = result as? Dictionary<String, Any> {
                DispatchQueue.main.async {
                    self.metadata = AppMetadata(name: self.app.name, bundleId: self.app.bundleId, dict: r)
                    self.tableView.reloadData()
                }
            }
        }
    }

    @objc func viewInAppStoreTapped() {
        let url = URL(string: "https://itunes.apple.com/us/app/app/id" + app.appId)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
        } else if section == SectionType.testflight.rawValue {
            return Rows.testflight.count
        } else if section == SectionType.metadata.rawValue {
            if metadata == nil { return 0 }
            return 1
        }
        return 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionType = SectionType(rawValue: section)
        return sectionType?.description
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            cell?.accessoryType = .disclosureIndicator
        }
        if indexPath.section == SectionType.appStore.rawValue {
            cell?.textLabel?.text = Rows.appstore[indexPath.row]
            if indexPath.row == Rows.appstore.index(of: "iOS") {
                if let metadata = self.metadata {
                    cell?.detailTextLabel?.text = metadata.liveVersion
                }
            }
        } else if indexPath.section == SectionType.testflight.rawValue {
            cell?.textLabel?.text = Rows.testflight[indexPath.row]
        } else {
            var metadataCell: AppMetadataTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "AppMetadataTableViewCell") as? AppMetadataTableViewCell
            if metadataCell == nil {
                metadataCell = UIView.loadFromNibNamed(nibNamed: "AppMetadataTableViewCell") as? AppMetadataTableViewCell
            }
            metadataCell?.configureView(metadata: metadata!)
            return metadataCell!
        }

        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SectionType.appStore.rawValue {
            if indexPath.row == Rows.appstore.index(of: "Reviews") {
                let reviewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReviewsViewController") as! ReviewsViewController
                reviewVC.app = app
                navigationController?.pushViewController(reviewVC, animated: true)
            } else if indexPath.row == Rows.appstore.index(of: "iOS") {
                let appVersionDetailVC = AppVersionDetailViewController()
                appVersionDetailVC.app = app
                appVersionDetailVC.appMetadata = metadata
                appVersionDetailVC.appVersionType = .live
                navigationController?.pushViewController(appVersionDetailVC, animated: true)
            }
        } else if indexPath.section == SectionType.testflight.rawValue {
            let testersVC = TestersViewController()
            testersVC.app = app
            navigationController?.pushViewController(testersVC, animated: true)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
