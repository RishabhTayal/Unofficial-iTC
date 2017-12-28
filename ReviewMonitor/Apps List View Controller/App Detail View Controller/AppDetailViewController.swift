//
//  AppDetailViewController.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/26/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit

class AppDetailViewController: UIViewController {

    enum RowType: Int {
        case testers
        case reviews
        case processingBuilds
        case count

        var description: String {
            switch self {
            case .testers:
                return "Testers"
            case .reviews:
                return "Reviews"
            case .processingBuilds:
                return "Processing Builds"
            default:
                return ""
            }
        }
    }

    @IBOutlet var tableView: UITableView!
    @IBOutlet var appImageView: UIImageView!
    @IBOutlet var appNameLabel: UILabel!

    var app: App?
    var processingBuildCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        appImageView.addBorder(1 / UIScreen.main.scale, color: UIColor.lightGray)
        appImageView.cornerRadius(8)
        if let imageUrl = app?.previewUrl {
            appImageView.sd_setImage(with: URL(string: imageUrl)!, completed: nil)
        } else {
            appImageView.image = UIImage(named: "empty_app_icon")
        }
        appNameLabel.text = app?.name
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)

        getProcessingBuilds()
    }

    func getProcessingBuilds() {
        ServiceCaller.getProcessingBuilds(bundleId: (app?.bundleId)!) { result, e in
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RowType.count.rawValue
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell?.accessoryType = .disclosureIndicator
        }
        let rowType = RowType(rawValue: indexPath.row)!
        if rowType == .processingBuilds {
            cell?.textLabel?.text = String(processingBuildCount) + " builds processing"
        } else {
            cell?.textLabel?.text = rowType.description
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch RowType(rawValue: indexPath.row)! {
        case RowType.testers:
            let testersVC = TestersViewController()
            testersVC.app = app
            navigationController?.pushViewController(testersVC, animated: true)
        case RowType.reviews:
            let reviewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReviewsViewController") as! ReviewsViewController
            reviewVC.app = app
            navigationController?.pushViewController(reviewVC, animated: true)
        default:
            tableView.deselectRow(at: indexPath, animated: true)
            break
        }
    }
}
