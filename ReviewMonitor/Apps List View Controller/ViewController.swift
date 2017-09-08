//
//  ViewController.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/7/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var list: [App] = []
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Apps"
        refreshControl.addTarget(self, action: #selector(getApps), for: .valueChanged)
        tableView.addSubview(refreshControl)

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.organize, target: self, action: #selector(manageAccountTapped))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getApps()
    }

    func manageAccountTapped() {
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let navC = UINavigationController(rootViewController: loginVC)
        navigationController?.present(navC, animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    func getApps() {
        refreshControl.beginRefreshing()
        ServiceCaller.getApps { result, error in
            if let result = result as? [[String: Any]] {
                self.list = []
                for appDict in result {
                    let app = App(dict: appDict)
                    self.list.append(app)
                }
            }
            DispatchQueue.main.async {
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
        cell.configure(app: list[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reviewVC = storyboard?.instantiateViewController(withIdentifier: "ReviewsViewController") as! ReviewsViewController
        reviewVC.app = list[indexPath.row]
        navigationController?.pushViewController(reviewVC, animated: true)
    }
}
