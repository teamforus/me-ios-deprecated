//
//  MAConfirmationSignUpViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 1/21/19.
//  Copyright © 2019 Foundation Forus. All rights reserved.
//

import UIKit
import CoreData

class MAConfirmationSignUpViewController: UIViewController {
    var primaryEmail: String!
    var givenName: String!
    var familyName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(authorizeToken(notifcation:)),
            name: NSNotification.Name(rawValue: "authorizeTokenSignUp"),
            object: nil)
    }
    
    @IBAction func openMailApp(_ sender: Any) {
        let mailURL = NSURL(string: "message://")!
        if UIApplication.shared.canOpenURL(mailURL as URL) {
            UIApplication.shared.open(mailURL as URL, options: [:],
                                      completionHandler: {
                                        (success) in }) }
    }
    

    @objc func authorizeToken(notifcation: Notification){
        AuthorizationEmailRequest.authorizeEmailSignUpToken(token: notifcation.userInfo?["authToken"] as! String, completion: { (response, statusCode) in
            if response.accessToken != nil {
                self.updateOldIndentity()
                self.saveNewIdentity(primaryEmail: self.primaryEmail, accessToken: response.accessToken, givenName: self.givenName, familyName: self.familyName)
                self.getCurrentUserByToken(accessToken: response.accessToken)
                self.performSegue(withIdentifier: "goToWalet", sender: nil)
            }else{
                AlertController.showWarning(withText: "Please try to send email again.".localized(), vc: self)
            }
        }) { (error) in }
    }

}
