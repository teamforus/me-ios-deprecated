//
//  MAPinCodeLoginViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/28/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Reachability
import Presentr
import CoreData

class MAPinCodeLoginViewController: MABaseViewController ,UITextFieldDelegate{
    @IBOutlet weak var codeUITextField: UITextField!
    @IBOutlet weak var digit1UILabel: UILabel!
    @IBOutlet weak var digit2UILabel: UILabel!
    @IBOutlet weak var digit3UILabel: UILabel!
    @IBOutlet weak var digit4UILabel: UILabel!
    @IBOutlet weak var digit5UILabel: UILabel!
    @IBOutlet weak var digit6UILabel: UILabel!
    @IBOutlet weak var viewPinCode: UIView!
    var timer : Timer! = Timer()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var response: Code!
    
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()
    let reachability = Reachability()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPinCode.layer.cornerRadius = 9.0
        viewPinCode.layer.shadowColor = UIColor.black.cgColor
        viewPinCode.layer.shadowOffset = CGSize(width: 0, height: 5)
        viewPinCode.layer.shadowOpacity = 0.1
        viewPinCode.layer.shadowRadius = 10.0
        viewPinCode.layer.masksToBounds = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if reachability.connection != .none{
            AuthorizationCodeRequest.createAuthorizationCode(completion: { (response, statusCode) in
                if response.authCode != nil{
                    self.response = response
                    let stringCode: String = "\(response.authCode!)"
                    if stringCode.count == 6{
                        self.digit1UILabel.text = String(stringCode[0])
                        self.digit2UILabel.text = String(stringCode[1])
                        self.digit3UILabel.text = String(stringCode[2])
                        self.digit4UILabel.text = String(stringCode[3])
                        self.digit5UILabel.text = String(stringCode[4])
                        self.digit6UILabel.text = String(stringCode[5])
                        UserDefaults.standard.setValue(response.authCode, forKey: "auth_code")
                        self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.checkAuthorizeToken), userInfo: nil, repeats: true)
                    }
                }
            }) { (error) in
                AlertController.showError(vc:self)
            }
        }else{
            AlertController.showInternetUnable(vc: self)
        }
    }
    
    @objc func checkAuthorizeToken(){
        Status.checkStatus(accessToken: response.accessTokenCode, completion: { (code, message) in
            if code == 200 {
                if message == "active"{
                    self.timer.invalidate()
                    self.updateOldIndentity()
                    self.saveNewIdentity(accessToken: self.response.accessTokenCode)
                    self.getCurrentUser(accessToken: self.response.accessTokenCode)
                    self.performSegue(withIdentifier: "goToWalet", sender: nil)
                }
            }
        }) { (error) in
            AlertController.showError(vc:self)
        }
    }
    
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //    let code = textField.text! + string
    //    switch code.count{
    //    case 1:
    //    digit1UITextField.text = string
    //    case 2:
    //    digit2UITextField.text = string
    //    case 3:
    //    digit3UITextField.text = string
    //    case 4:
    //    digit4UITextField.text = string
    //    case 5:
    //    digit5UITextField.text = string
    //    case 6:
    //    digit6UITextField.text = string
    //    default: break
    //    }
    //    return (textField.text?.count)! + (string.count - range.length) <= 6;
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func saveNewIdentity(accessToken: String){
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format:"accessToken == %@", accessToken)
        
        do{
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count == 0 {
                let newUser = NSManagedObject(entity: entity!, insertInto: context)
                newUser.setValue(true, forKey: "currentUser")
                newUser.setValue(accessToken, forKey: "accessToken")
                newUser.setValue(UserDefaults.standard.string(forKey: ALConstants.kPincode), forKey: "pinCode")
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            }else{
                results![0].setValue(accessToken, forKey: "accessToken")
                results![0].setValue(true, forKey: "currentUser")
                results![0].setValue(UserDefaults.standard.string(forKey: ALConstants.kPincode), forKey: "pinCode")
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            }
        } catch{
            
        }
    }
    
    func updateOldIndentity(){
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format:"currentUser == YES")
        
        do{
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                results![0].setValue(false, forKey: "currentUser")
                
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            }
        } catch{
            
        }
    }
    
    func getCurrentUser(accessToken: String!){
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format:"accessToken == %@", accessToken)
        
        do{
            let results = try context.fetch(fetchRequest) as? [User]
            UserShared.shared.currentUser = results![0]
            
        } catch{
            
        }
    }
    
    @IBAction func loginWithCode(_ sender: Any) {
        if reachability.connection != .none {
            if UserShared.shared.currentUser != nil {
                AuthorizationCodeRequest.authorizeCode(completion: { (response, statusCode) in
                    if response.success != nil {
                        self.performSegue(withIdentifier: "goToWalet", sender: nil)
                    }else if response.message != nil {
                        AlertController.showWarning(withText: response.message, vc: self)
                    }
                }) { (error) in
                    AlertController.showError(vc:self)
                }
            }else {
                AlertController.showWarning(withText: NSLocalizedString("This device in not authorize", comment: ""), vc: self)
            }
        }else {
            AlertController.showInternetUnable(vc: self)
        }
    }
    
    @IBAction func aboutAction(_ sender: Any) {
        let popupTransction =  MAAboutMeViewController(nibName: "MAAboutMeViewController", bundle: nil)
        popupTransction.titleDetail = NSLocalizedString("How does it work?", comment: "")
        popupTransction.descriptionDetail = NSLocalizedString("If you already have a Me identity and logged into the web-shop, then go to the web-shop and click on 'Authorize device' and enter the code that is visible on this screen.", comment: "")
        self.presenter.presentationType = .popup
        self.presenter.transitionType = nil
        self.presenter.dismissTransitionType = nil
        self.presenter.keyboardTranslationType = .compress
        self.customPresentViewController(self.presenter, viewController: popupTransction, animated: true, completion: nil)
    }
    
}
