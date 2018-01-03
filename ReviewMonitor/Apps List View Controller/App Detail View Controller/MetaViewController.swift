//
//  MetaViewController.swift
//  ReviewMonitor
//
//  Created by Eliott Hauteclair on 3/01/18.
//  Copyright © 2018 Tayal, Rishabh. All rights reserved.
//

import UIKit

protocol MetaViewControllerDelegate: class {
    func metaControllerDidDismiss()
}

class MetaViewController: UIViewController {

    weak var delegate: AccountsViewControllerDelegate?

    var m = Meta()

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var copyright: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var keyword: UILabel!
    @IBOutlet weak var support: UILabel!
    @IBOutlet weak var marketing: UILabel!
    @IBOutlet weak var available: UILabel!
    @IBOutlet weak var watchos: UILabel!
    @IBOutlet weak var beta: UILabel!
    @IBOutlet weak var bundleId: UILabel!
    @IBOutlet weak var primaryCateg: UILabel!
    @IBOutlet weak var primaryCategSub1: UILabel!
    @IBOutlet weak var primaryCategSub2: UILabel!
    @IBOutlet weak var secondaryCateg: UILabel!
    @IBOutlet weak var secondaryCategSub1: UILabel!
    @IBOutlet weak var secondaryCategSub2: UILabel!

    //    var m = Meta()

    override func viewDidLoad() {
        super.viewDidLoad()

        print(m)

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_close"), style: .plain, target: self, action: #selector(cancelTapped))

        name.text = m.name
        version.text = m.version
        copyright.text = m.copyright
        status.text = m.status
        language.text = m.languages
        keyword.text = m.keywords
        support.text = m.support
        marketing.text = m.marketing
        available.text = m.available
        watchos.text = m.watchos
        beta.text = m.beta
        bundleId.text = m.bundleID
        primaryCateg.text = m.primaryCateg
        primaryCategSub1.text = m.primaryCategSub1
        primaryCategSub2.text = m.primaryCategSub2
        secondaryCateg.text = m.secondaryCateg
        secondaryCategSub1.text = m.secondaryCategSub1
        secondaryCategSub2.text = m.secondaryCategSub2

        // Do any additional setup after loading the view.
    }

    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
