//
//  SettingsViewController.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 12/28/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit
import SafariServices
import LocalAuthentication

class SettingsViewController: UIViewController {

    var biometricType: BiometricType {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            print(error?.localizedDescription ?? "")
            return .none
        }

        if #available(iOS 11.0, *) {
            switch context.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            }
        } else {
            return .touchID
        }
    }

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
        tableView.register(AuthCell.nib, forCellReuseIdentifier: "auth")
        view.addSubview(tableView)

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "X", style: .plain, target: self, action: #selector(cancelTapped))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    let def = UserDefaults.standard

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

enum BiometricType {
    case none
    case touchID
    case faceID
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell?.accessoryType = .disclosureIndicator
        }

        if indexPath.row == 0 {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "auth", for: indexPath) as! AuthCell
            configureBiorMetricsCell(cell: cell2)
            return cell2
        }
        if indexPath.row == 1 {
            cell?.textLabel?.text = "Report a Bug"
        }
        if indexPath.row == 2 {
            cell?.textLabel?.text = "Share App"
        }
        return cell!
    }

    @objc func switchChanged(_ mySwitch: UISwitch) {
        switch mySwitch.isOn {
        case true:
            def.set(true, forKey: "useBiometrics")
        case false:
            def.set(false, forKey: "useBiometrics")
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let url = URL(string: "https://github.com/RishabhTayal/ReviewMonitor/issues/new")!
            let safari = SFSafariViewController(url: url)
            present(safari, animated: true, completion: nil)
        }
        if indexPath.row == 2 {
            let shareSheet = UIActivityViewController(activityItems: ["Download ReviewMonitor, an iTunes Connect manager app from TestFlight.\nhttp://itc-onboarding.herokuapp.com"], applicationActivities: nil)
            present(shareSheet, animated: true, completion: nil)
        }
    }
}

// Configure TableView Cells
extension SettingsViewController {
    func configureBiorMetricsCell(cell: AuthCell) {
        if def.bool(forKey: "useBiometrics") {
            cell.onOff.setOn(true, animated: true)
        } else {
            cell.onOff.setOn(false, animated: true)
        }
        if biometricType == .faceID {
            cell.title.text = "Unlock with Face ID"
        } else if biometricType == .touchID {
            cell.title.text = "Unlock with Touch ID"
        } else {
            cell.isHidden = true
        }
        cell.onOff.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
    }
}

class AuthCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var onOff: UISwitch!

    static let nib = UINib(nibName: "AuthCell", bundle: nil)
}
