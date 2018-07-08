//
//  MAQRLoginPupUpViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/8/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MAQRLoginPupUpViewController: MABasePopUpViewController {
    @IBOutlet weak var imageQR: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageQR.generateQRCode(from: "Login with QR")
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
