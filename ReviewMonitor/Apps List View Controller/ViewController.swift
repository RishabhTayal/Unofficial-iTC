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
    let ud = UserDefaults()
    let hasFav = UserDefaults.standard.integer(forKey: "noOfFav")

    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .bottomHalf)
        presenter.transitionType = TransitionType.coverVertical
        presenter.dismissOnSwipe = false
        presenter.blurBackground = true
        return presenter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        refreshControl.addTarget(self, action: #selector(getApps), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = UIView()

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "accounts"), style: .plain, target: self, action: #selector(manageAccountTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_settings"), style: .plain, target: self, action: #selector(settingsTapped))
        getApps()
    }

    @objc func settingsTapped() {
        let settingsVC = SettingsViewController()
        present(UINavigationController(rootViewController: settingsVC), animated: true, completion: nil)
    }

    @objc func manageAccountTapped() {
        let accountsVC = AccountsViewController(nibName: "AccountsViewController", bundle: nil)
        accountsVC.delegate = self
        let navC = UINavigationController(rootViewController: accountsVC)
        customPresentViewController(presenter, viewController: navC, animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if ServiceCaller.getBaseUrl().count == 0 {
            ServiceCaller.askForBaseURL(controller: self)
        }
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    func configureView() {
        title = AccountManger.getCurrentAccount()?.teamName
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
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favourite = UIContextualAction(style: .normal, title: "Favourite") { contextAction, view, isSuccess in
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.list[indexPath.row])
            print(self.list[indexPath.row])
            let no = self.ud.integer(forKey: "noOfFav")
            self.ud.set(encodedData, forKey: "favourites\(no)")
            print(encodedData)
            self.ud.set(no + 1, forKey: "noOfFav")
            self.ud.synchronize()

            isSuccess(true)
        }

        return UISwipeActionsConfiguration(actions: [favourite])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if hasFav > 0 {
            return 2
        }
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasFav > 0 {
            if section == 0 {
                return hasFav
            }
            return list.count
        }
        return list.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if hasFav > 0 && section == 0 {
            return "Favourites"
        }
        return "Your Apps"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AppsListTableViewCell
        cell.accessoryType = .disclosureIndicator

        if hasFav > 0 && indexPath.section == 0 {
            let favouriteUD = ud.data(forKey: "favourites\(indexPath.row)")
            let favApp = NSKeyedUnarchiver.unarchiveObject(with: favouriteUD!) as! App
            cell.configure(app: favApp)
        } else {
            cell.configure(app: list[indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDetail = AppDetailViewController(nibName: "AppDetailViewController", bundle: nil)

        if hasFav > 0 && indexPath.section == 0 {
            let favouriteUD = ud.data(forKey: "favourites\(indexPath.row)")
            let favApp = NSKeyedUnarchiver.unarchiveObject(with: favouriteUD!) as! App
            appDetail.app = favApp
        } else {
            appDetail.app = list[indexPath.row]
        }
        navigationController?.pushViewController(appDetail, animated: true)
    }
}

extension ViewController: AccountsViewControllerDelegate {
    func accountsControllerDidDismiss() {
        list = []
        tableView.reloadData()
        configureView()
        getApps()
    }
}
