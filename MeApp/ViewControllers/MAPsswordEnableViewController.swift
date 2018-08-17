//
//  MAPsswordEnableViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/31/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MAPsswordEnableViewController: MABaseViewController, AppLockerDelegate {
   
    
    var appLocker: AppLocker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func createPasscode(_ sender: Any) {
        var appearance = ALAppearance()
        appearance.image = UIImage(named: "lock")!
        appearance.title = "Create passcode"
        appearance.subtitle = "Your passcode is required \n to enable Face ID"
        appearance.isSensorsEnabled = true
        appearance.delegate = self
        
        AppLocker.present(with: .create, and: appearance)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
       performSegue(withIdentifier: "goToWalet", sender: self)
//        let emailObject = ["primary_email" : emailSkyFloatingTextField.text,
//                           "family_name" : familyNameField.text,
//                           "given_name" : givenNameField.text]
//        let parameters: Parameters = ["pin_code" : "2460",
//                                      "records" : emailObject]
//        RequestNewIndetity.createnewIndentity(parameters: parameters,
//                                              completion: { (response) in
//                                                if response.errors == nil {
//                                                    self.updateOldIndentity()
//                                                    self.saveNewIdentity(accessToken: response.accessToken, pinCode: 2460)
//                                                    self.getCurrentUser(primaryEmai: self.emailSkyFloatingTextField.text)
//                                                    RecordCategoryRequest.createRecordCategory(completion: { (response) in
//                                                        
//                                                    }) { (error) in
//                                                        
//                                                    }
//                                                    if UserDefaults.standard.string(forKey: ALConstants.kPincode) != "" && UserDefaults.standard.string(forKey: ALConstants.kPincode) != nil{
//                                                        self.performSegue(withIdentifier: "goToWalet", sender: self)
//                                                    }else{
//                                                        self.performSegue(withIdentifier: "goToPassword", sender: self)
//                                                    }
//                                                }else {
//                                                    let error = MessageView.viewFromNib(layout: .tabView)
//                                                    error.configureTheme(.error)
//                                                    error.configureContent(title: "Invalid data", body: response.errors?.recordMessage != nil ? response.errors?.recordMessage.first : "Email already is used" , iconImage: nil, iconText: "", buttonImage: nil, buttonTitle: "YES") { _ in
//                                                        SwiftMessages.hide()
//                                                    }
//                                                    error.button?.setTitle("OK", for: .normal)
//                                                    
//                                                    SwiftMessages.show( view: error)
//                                                }
//                                                
//        }, failure: { (error) in
//            let error = MessageView.viewFromNib(layout: .tabView)
//            error.configureTheme(.error)
//            error.configureContent(title: "Invalid email", body: "Something go wrong, please try again!", iconImage: nil, iconText: "", buttonImage: nil, buttonTitle: "YES") { _ in
//                SwiftMessages.hide()
//            }
//            error.button?.setTitle("OK", for: .normal)
//            
//            SwiftMessages.show( view: error)
//        })
    }
    
    func closePinCodeView(typeClose: typeClose) {
        switch typeClose {
        case .cancel:
            performSegue(withIdentifier: "goToWalet", sender: self)
            break
        case .create:
            performSegue(withIdentifier: "goToWalet", sender: self)
            break
        default:
            break
        }
    }

}
