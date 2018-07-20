//
//  MATextViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/20/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MATextViewController: UIViewController {
    @IBOutlet weak var textUITextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textUITextView.layer.cornerRadius = 6
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
