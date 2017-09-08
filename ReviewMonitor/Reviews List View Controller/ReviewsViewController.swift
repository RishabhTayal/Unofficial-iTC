//
//  ReviewsViewController.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/7/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ReviewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var reviews: [Review] = []
    var app: App!

    var refreshControl: UIRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = app.name
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        refreshControl.addTarget(self, action: #selector(getReviews), for: .valueChanged)
        tableView.addSubview(refreshControl)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterTapped))
        getReviews()
    }

    func filterTapped() {
    }

    func getReviews() {
        refreshControl.beginRefreshing()
        ServiceCaller.getReviews(app: app) { result, error in
            if let result = result as? [[String: Any]] {
                self.reviews = []
                for reviewDict in result {
                    let review = Review(dict: reviewDict)
                    self.reviews.append(review)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }

    func promptForResponse(review: Review) {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.addTextField { tf in
            tf.placeholder = "Enter developer response"
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.default, handler: { action in
            let textField = alertController.textFields?.first
            ServiceCaller.postResponse(reviewId: review.id, bundleId: self.app.bundleId, response: textField!.text!, completionBlock: { result, error in
                DispatchQueue.main.async {
                    self.getReviews()
                }
            })
        }))
        present(alertController, animated: true, completion: nil)
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
        return 120
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
        //        promptForResponse(review: review)
        tweetReview(review: review)
    }
}

extension ReviewsViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "No reviews yet.")
    }
}
