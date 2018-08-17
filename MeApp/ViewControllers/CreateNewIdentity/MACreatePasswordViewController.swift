//
//  MACreatePasswordViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 8/17/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit

class MACreatePasswordViewController: UIViewController {
    var primaryEmail: String!
    var givenName: String!
    var familyName: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let creatPassVC = segue.destination as! MAPsswordEnableViewController
        creatPassVC.primaryEmail = primaryEmail
        creatPassVC.givenName = givenName
        creatPassVC.familyName = familyName
    }

}
