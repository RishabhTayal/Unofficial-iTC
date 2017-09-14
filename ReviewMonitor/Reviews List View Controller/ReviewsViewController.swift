//
//  ReviewsViewController.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/7/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import MBProgressHUD

class ReviewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var reviews: [Review] = []
    var app: App!

    var refreshControl: UIRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = app.name
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self

        tableView.tableFooterView = UIView()
        refreshControl.addTarget(self, action: #selector(getReviews), for: .valueChanged)
        tableView.addSubview(refreshControl)

        //        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterTapped))
        getReviews()
    }

    func filterTapped() {
    }

    func getReviews() {
        refreshControl.beginRefreshing()
        MBProgressHUD.showAdded(to: view, animated: true)
        ServiceCaller.getReviews(app: app) { result, error in
            if let result = result as? [[String: Any]] {
                self.reviews = []
                for reviewDict in result {
                    let review = Review(dict: reviewDict)
                    self.reviews.append(review)
                }
            }
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }

    func promptForResponse(review: Review) {
        let textEditor = ResponseEditorViewController(nibName: "ResponseEditorViewController", bundle: nil)
        textEditor.review = review
        navigationController?.pushViewController(textEditor, animated: true)
    }

    func tweetReview(review: Review) {
        var urlString = "https://twitter.com/intent/tweet?text=" + review.review!
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: urlString)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension ReviewsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ReviewsListTableViewCell
        cell.config(review: reviews[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let review = reviews[indexPath.row]
        promptForResponse(review: review)
        //        tweetReview(review: review)
    }
}

extension ReviewsViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "No reviews yet.")
    }

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return !refreshControl.isRefreshing
    }
}
