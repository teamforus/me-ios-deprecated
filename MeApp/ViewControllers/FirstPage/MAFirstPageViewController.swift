//
//  MAFirstPageViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/28/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MAFirstPageViewController: MABaseViewController {
    @IBOutlet weak var createNewAccountButton: UIButton!
    
    @IBOutlet weak var haveIdentityButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        createNewAccountButton.layer.cornerRadius = 9.0
        createNewAccountButton.layer.shadowColor = UIColor.black.cgColor;
        createNewAccountButton.layer.shadowOffset = CGSize(width: 0, height: 10);
        createNewAccountButton.layer.shadowOpacity = 0.2;
        createNewAccountButton.layer.shadowRadius = 10.0;
        createNewAccountButton.layer.masksToBounds = false;
        //shadow for haveIndetityButton
        haveIdentityButton.layer.cornerRadius = 9.0
        haveIdentityButton.layer.shadowColor = UIColor.black.cgColor;
        haveIdentityButton.layer.shadowOffset = CGSize(width: 0, height: 0);
        haveIdentityButton.layer.shadowOpacity = 0.2;
        haveIdentityButton.layer.shadowRadius = 10.0;
        haveIdentityButton.layer.masksToBounds = false;
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
