//
//  TestersViewController.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/25/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit
import MBProgressHUD

class TestersViewController: UIViewController {

    var tableView: UITableView!

    var app: App?
    var testers: [Tester] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: view.frame)
        tableView.dataSource = self
        //        tableView.delegate = self
        tableView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        view.addSubview(tableView)
        getTesters()
    }

    func getTesters() {
        MBProgressHUD.showAdded(to: view, animated: true)
        ServiceCaller.getTesters(bundleId: (app?.bundleId)!) { result, error in
            if let result = result as? [[String: Any]] {
                self.testers = []
                for testerDict in result {
                    let tester = Tester(dict: testerDict)
                    self.testers.append(tester)
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
}

extension TestersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        let tester = testers[indexPath.row]
        cell?.textLabel?.text = tester.firstName + " " + tester.lastName
        cell?.detailTextLabel?.text = tester.email
        return cell!
    }
}
