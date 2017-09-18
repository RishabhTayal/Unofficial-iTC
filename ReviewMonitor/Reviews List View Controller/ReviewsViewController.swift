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

    var originalReviews: [Review] = []
    var reviews: [Review] = []
    var app: App!
    var appliedFilter: ReviewFilter!

    var refreshControl: UIRefreshControl = UIRefreshControl()
    var savedIndexPathForLongPressedCell: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = app.name
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self

        tableView.tableFooterView = UIView()
        refreshControl.addTarget(self, action: #selector(getReviews), for: .valueChanged)
        tableView.addSubview(refreshControl)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterTapped))
        getReviews()
    }

    func filterTapped() {
        let filterVC = ReviewFilterViewController(nibName: "ReviewFilterViewController", bundle: nil)
        filterVC.delegate = self
        filterVC.filter = appliedFilter
        present(UINavigationController(rootViewController: filterVC), animated: true, completion: nil)
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
                self.originalReviews = self.reviews
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
        textEditor.app = app
        navigationController?.pushViewController(textEditor, animated: true)
    }

    func tweetReview(_ menu: UIMenuController) {
        if let indexPath = savedIndexPathForLongPressedCell {
            let review = reviews[indexPath.row]
            let tweetText = (review.rating?.stringValue)! + " Star Review: \"" + review.review! + "\""
            var urlString = "https://twitter.com/intent/tweet?text=" + tweetText
            urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let url = URL(string: urlString)!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

extension ReviewsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ReviewsListTableViewCell
        cell.config(review: reviews[indexPath.row])
        if cell.gestureRecognizers == nil {
            let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
            cell.addGestureRecognizer(recognizer)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let review = reviews[indexPath.row]
        promptForResponse(review: review)
    }

    func longPress(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            let tableViewCell = recognizer.view as! ReviewsListTableViewCell
            tableViewCell.becomeFirstResponder()
            savedIndexPathForLongPressedCell = tableView.indexPath(for: tableViewCell)

            let tweet = UIMenuItem(title: "Tweet", action: #selector(tweetReview(_:)))
            let menu = UIMenuController.shared
            menu.menuItems = [tweet]
            menu.setTargetRect(tableViewCell.frame, in: (tableViewCell.superview)!)
            menu.setMenuVisible(true, animated: true)
        }
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

extension ReviewsViewController: ReviewFilterViewControllerDelegate {
    func reviewFilterDidSelectFilter(filter: ReviewFilter) {
        appliedFilter = filter
        reviews = originalReviews
        reviews = reviews.filter({ (review) -> Bool in
            (review.rating?.floatValue)! <= filter.maxRating && review.rating!.floatValue >= filter.minRating
        })
        reviews = reviews.filter({ (review) -> Bool in
            if filter.developerResponded {
                return review.rawDeveloperResponse != nil
            } else {
                return review.rawDeveloperResponse == nil
            }
        })
        tableView.reloadData()
    }
}
