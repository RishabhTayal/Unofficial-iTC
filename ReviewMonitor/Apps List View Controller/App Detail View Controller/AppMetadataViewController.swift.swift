//
//  MetaViewController.swift
//  ReviewMonitor
//
//  Created by Eliott Hauteclair on 3/01/18.
//  Copyright © 2018 Tayal, Rishabh. All rights reserved.
//

import UIKit

protocol AppMetadataViewControllerDelegate: class {
    func metaControllerDidDismiss()
}

class AppMetadataViewController: UIViewController {

    weak var delegate: AppMetadataViewControllerDelegate?

    var metadata = AppMetadata()

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

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_close"), style: .plain, target: self, action: #selector(cancelTapped))

        name.text = metadata.name
        version.text = metadata.version
        copyright.text = metadata.copyright
        status.text = metadata.status
        language.text = metadata.languages
        keyword.text = metadata.keywords
        support.text = metadata.support
        marketing.text = metadata.marketing
        available.text = metadata.available
        watchos.text = metadata.watchos
        beta.text = metadata.beta
        bundleId.text = metadata.bundleID
        primaryCateg.text = metadata.primaryCateg
        primaryCategSub1.text = metadata.primaryCategSub1
        primaryCategSub2.text = metadata.primaryCategSub2
        secondaryCateg.text = metadata.secondaryCateg
        secondaryCategSub1.text = metadata.secondaryCategSub1
        secondaryCategSub2.text = metadata.secondaryCategSub2

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
