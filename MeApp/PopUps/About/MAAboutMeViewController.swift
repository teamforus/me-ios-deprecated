//
//  MAAboutMeViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 8/31/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit

class MAAboutMeViewController: MABasePopUpViewController {
    var titleDetail: String!
    var descriptionDetail: String!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleDetail
        descriptionLabel.text = descriptionDetail
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
