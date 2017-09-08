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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getApps()
    }

    func getApps() {
        ServiceCaller.getApps { (result, error) in
            if let result = result as? [[String: Any]] {
                for appDict in result {
                    let app = App.init(dict: appDict)
                    self.list.append(app)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = list[indexPath.row].name
        if let url = list[indexPath.row].previewUrl {
        cell?.imageView?.sd_setImage(with: URL.init(string: url)!, completed: nil)
        } else {
            cell?.imageView?.image = nil
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reviewVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewsViewController") as! ReviewsViewController
        self.navigationController?.pushViewController(reviewVC, animated: true)
    }
    
}
