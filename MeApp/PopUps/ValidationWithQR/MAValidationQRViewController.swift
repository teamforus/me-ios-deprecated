//
//  MAValidationQRViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/23/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MAValidationQRViewController: MABasePopUpViewController {
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var viewBody: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

      qrCodeImage.generateQRCode(from: "MeApp")
        viewBody.layer.masksToBounds = true
        viewBody.layer.cornerRadius = 8.0
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
