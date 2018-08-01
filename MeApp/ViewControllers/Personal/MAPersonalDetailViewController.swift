//
//  MAPersonalDetailViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/30/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Alamofire

class MAPersonalDetailViewController: MABaseViewController {
    @IBOutlet weak var nameCategory: UILabel!
    var record: Record!
    @IBOutlet weak var valueRecord: UILabel!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var imageFavorite: UIImageView!
    @IBOutlet weak var qrCodeImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        validationLabel.isHidden = true
        if record.key == "primary_email"{
            nameCategory.text = "Primary E-mail"
            valueRecord.text = record.value
        }else if record.key == "family_name"{
            nameCategory.text = "Family name"
            valueRecord.text = record.value
        }else if record.key == "telephone"{
            nameCategory.text = "Phone Number"
            valueRecord.text = record.value
        }else if record.key == "given_name"{
            nameCategory.text = "Given Name"
            valueRecord.text = record.value
        }else if record.key == "gender"{
            nameCategory.text = "Gender"
            valueRecord.text = record.value
        }else if record.key == "children"{
            nameCategory.text = "Children"
            valueRecord.text = record.value
        }
        
        let parameter: Parameters = ["record_id" : record.id]
        
        RecordsRequest.createValidationTokenRecord(parameters: parameter, completion: { (response) in
            self.qrCodeImage.generateQRCode(from: "uuid:\(response.uuid!)")
        }) { (error) in }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteRecord(_ sender: Any) {
    }
    
    @IBAction func addFavorite(_ sender: Any) {
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
