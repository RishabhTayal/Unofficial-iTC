//
//  ViewController.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/7/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD
import Presentr

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var list: [App] = []
    var refreshControl = UIRefreshControl()

    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .bottomHalf)
        presenter.transitionType = TransitionType.coverVertical
        presenter.dismissOnSwipe = true
        presenter.blurBackground = true
        return presenter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = AccountManger.getCurrentAccount()?.teamName

        refreshControl.addTarget(self, action: #selector(getApps), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = UIView()

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "accounts"), style: .plain, target: self, action: #selector(manageAccountTapped))

        getApps()
    }

    @objc func manageAccountTapped() {
        let accountsVC = AccountsViewController(nibName: "AccountsViewController", bundle: nil)
        accountsVC.delegate = self
        let navC = UINavigationController(rootViewController: accountsVC)
        customPresentViewController(presenter, viewController: navC, animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    @objc func getApps() {
        refreshControl.beginRefreshing()
        MBProgressHUD.showAdded(to: view, animated: true)
        ServiceCaller.getApps { result, error in
            if let result = result as? [[String: Any]] {
                self.list = []
                for appDict in result {
                    let app = App(dict: appDict)
                    self.list.append(app)
                }
            }
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AppsListTableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.configure(app: list[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let appDetail = AppDetailViewController(nibName: "AppDetailViewController", bundle: nil)
        appDetail.app = list[indexPath.row]
        navigationController?.pushViewController(appDetail, animated: true)
    }
}

extension ViewController: AccountsViewControllerDelegate {
    func accountsControllerDidDismiss() {
        list = []
        tableView.reloadData()
        getApps()
    }
}
