//
//  MALoginWithQRViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/25/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Presentr
import Alamofire
import ISHPullUp
import CoreData
import Reachability
import AssistantKit

class MALoginWithQRViewController: MABaseViewController, MARegistrationViewControllerDelegate, MASignUpViewControllerDelegate {
    @IBOutlet weak var qrBodyView: UIView!
    @IBOutlet weak var loginWithQRButton: UIButton!
    @IBOutlet weak var loginWithPinCodeButton: UIButton!
    @IBOutlet weak var loginWithEmailButton: UIButton!
    @IBOutlet weak var codeUITextField: UITextField!
    @IBOutlet weak var digit1UILabel: UILabel!
    @IBOutlet weak var digit2UILabel: UILabel!
    @IBOutlet weak var digit3UILabel: UILabel!
    @IBOutlet weak var digit4UILabel: UILabel!
    @IBOutlet weak var digit5UILabel: UILabel!
    @IBOutlet weak var digit6UILabel: UILabel!
    @IBOutlet weak var constraintBottom: NSLayoutConstraint!
    
    var timer : Timer! = Timer()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var response: Code!
    weak var pullUpController: ISHPullUpViewController!
    let reachability = Reachability()!
    var newIndetity: NewIdentity!
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    var pinCode: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screen = Device.screen
        switch screen {
        case .inches_5_8:
            constraintBottom.constant = 110
            break
        default:
            break
        }
        NotificationCenter.default.addObserver(self, selector: #selector(goToWalet), name: Notification.Name("TokenIsValidate"), object: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format:"currentUser == YES")
        do{
            let results = try context.fetch(fetchRequest) as? [User]
            if results?.count != 0 {
                UserShared.shared.currentUser = results![0]
            }
        } catch{}
        
        if reachability.connection != .none{
            AuthorizationCodeRequest.createAuthorizationCode(completion: { (response, statusCode) in
                if response.authCode != nil{
                    self.response = response
                    let stringCode: String = "\(response.exchange_token!)"
                    if stringCode.count == 6{
                        self.digit1UILabel.text = String(stringCode[0])
                        self.digit2UILabel.text = String(stringCode[1])
                        self.digit3UILabel.text = String(stringCode[2])
                        self.digit4UILabel.text = String(stringCode[3])
                        self.digit5UILabel.text = String(stringCode[4])
                        self.digit6UILabel.text = String(stringCode[5])
                        UserDefaults.standard.setValue(response.exchange_token, forKey: "auth_code")
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
    
    @objc func goToWalet(){
        performSegue(withIdentifier: "goToWalet", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func confirmPinCode(_ controller: MASignUpViewController, pinCode: String) {
        self.pinCode = pinCode
    }
    
    
    @IBAction func loginWithQr(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("togleStateWindow"), object: nil)
    }
    //MARK : MARegistrationViewControllerDelegate
    
    func confirmationEmail(_ controller: MARegistrationViewController, confirmationSuccess: Bool, email:String) {
        controller.dismiss(animated: true, completion: nil)
        if confirmationSuccess {
            self.performSegue(withIdentifier: "enterToWallet", sender: nil)
        }else{
            let popupTransction =  MAFailValidationViewController(nibName: "MAFailValidationViewController", bundle: nil)
            presenter.presentationType = .popup
            presenter.transitionType = nil
            presenter.dismissTransitionType = nil
            presenter.keyboardTranslationType = .compress
            customPresentViewController(presenter, viewController: popupTransction, animated: true, completion: nil)
        }
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
    
}
