//
//  SettingsViewController.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 12/28/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit
import SafariServices

class SettingsViewController: UIViewController {

    var tableView: UITableView!

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"

        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = tableFooterView()
        view.addSubview(tableView)

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }

    func tableFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let label = UILabel(frame: footerView.bounds)
        let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        label.text = "Version: " + appVersionString + " (" + buildNumber + ")"
        label.textAlignment = .center
        label.textColor = UIColor.darkGray
        footerView.addSubview(label)
        return footerView
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell?.accessoryType = .disclosureIndicator
        }
        cell?.textLabel?.text = "Report a Bug"
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: "https://github.com/RishabhTayal/ReviewMonitor/issues/new")!
        let safari = SFSafariViewController(url: url)
        present(safari, animated: true, completion: nil)
    }
}
