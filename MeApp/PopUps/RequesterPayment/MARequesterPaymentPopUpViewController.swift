//
//  MARequesterPaymentPopUpViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 10/24/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit

class MARequesterPaymentPopUpViewController: MABaseViewController {
    @IBOutlet weak var providerNameLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var voucherNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func acceptPayment(_ sender: Any) {
    }
    
    @IBAction func declinePayment(_ sender: Any) {
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
