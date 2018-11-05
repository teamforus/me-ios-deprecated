//
//  MAContentProfileViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 8/24/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit
import LocalAuthentication
import CoreData
import Alamofire
import Reachability
import Presentr

class MAContentProfileViewController: MABaseViewController, AppLockerDelegate {
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var closeUIButton: UIButton!
    var isCloseButtonHide: Bool!
    @IBOutlet weak var switchFaceID: UISwitch!
    @IBOutlet weak var faceIdImage: UIImageView!
    @IBOutlet weak var faceIdLabel: UILabel!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileEmailLabel: UILabel!
    @IBOutlet weak var passcodeLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var turnOffPascodeView: CustomCornerUIView!
    @IBOutlet weak var changePasscodeView: CustomCornerUIView!
    @IBOutlet weak var verticalSpacingFaceIdLogin: NSLayoutConstraint!
    @IBOutlet weak var heightButtonsView: NSLayoutConstraint!
    var deletePasscode: Bool = false
    
    let reachability = Reachability()!
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()
    
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //        UserDefaults.standard.set("0000", forKey: ALConstants.kPincode)
        //        UserDefaults.standard.synchronize()
        //        updateIndentity()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.string(forKey: ALConstants.kPincode) == "" || UserDefaults.standard.string(forKey: ALConstants.kPincode) == nil{
            turnOffPascodeView.isHidden = true
            passcodeLabel.text = "Add 4-digit passcode"
            heightButtonsView.constant = 124
            verticalSpacingFaceIdLogin.constant = 10
        }else{
            heightButtonsView.constant = 194
            turnOffPascodeView.isHidden = false
            passcodeLabel.text = "Change 4-digit passcode"
        }
        
        
        closeUIButton.isHidden = isCloseButtonHide ?? true
        if UserDefaults.standard.bool(forKey: "isWithTouchID"){
            switchFaceID.isOn = true
        }else {
            switchFaceID.isOn = false
        }
        
        if !faceIDAvailable(){
            faceIdImage.image = #imageLiteral(resourceName: "touchId")
            faceIdLabel.text = "Touch ID aanzetten"
        }
        if UserShared.shared.currentUser.primaryEmail != nil{
            profileNameLabel.text = "\(UserShared.shared.currentUser.firstName!) \(UserShared.shared.currentUser.lastName!)"
        }
        profileEmailLabel.text = UserShared.shared.currentUser.primaryEmail
        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        appVersionLabel.text = nsObject as? String
    }
    
    
    func faceIDAvailable() -> Bool {
        if #available(iOS 11.0, *) {
            let context = LAContext()
            return (context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: nil) && context.biometryType == .faceID)
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func faceIdEnable(_ sender: Any) {
        if (sender as! UISwitch).isOn{
            UserDefaults.standard.set(true, forKey: "isWithTouchID")
        }else{
            UserDefaults.standard.set(false, forKey: "isWithTouchID")
        }
        
    }
    
    @IBAction func editPasscode(_ sender: Any) {
        if reachability.connection != .none{
            if UserDefaults.standard.string(forKey: ALConstants.kPincode) != "" && UserDefaults.standard.string(forKey: ALConstants.kPincode) != nil{
                var appearance = ALAppearance()
                appearance.image = UIImage(named: "lock")!
                appearance.title = "Edit passcode"
                appearance.subtitle = "Enter your old passcode"
                appearance.isSensorsEnabled = true
                appearance.cancelIsVissible = true
                appearance.delegate = self
                
                AppLocker.present(with: .change, and: appearance, withController: self)
            }else{
//                UserDefaults.standard.set("", forKey: ALConstants.kPincode)
                var appearance = ALAppearance()
                appearance.image = UIImage(named: "lock")!
                appearance.title = "Inlogcode"
                appearance.subtitle = "Maak een inlogcode aan"
                appearance.isSensorsEnabled = true
                appearance.cancelIsVissible = false
                appearance.delegate = self
                
                AppLocker.present(with: .create, and: appearance, withController: self)
            }
        }else {
            AlertController.showInternetUnable(vc: self)
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        self.logOutProfile()
    }
    
    func logOutProfile(){
        //        self.parent?.dismiss(animated: true, completion: nil)
        if UserDefaults.standard.string(forKey: ALConstants.kPincode) != "" && UserDefaults.standard.string(forKey: ALConstants.kPincode) != nil{
            var appearance = ALAppearance()
            appearance.image = UIImage(named: "lock")!
            appearance.title = "Inlogcode"
            appearance.subtitle = "Stel in een inlogcode in"
            appearance.isSensorsEnabled = true
            appearance.cancelIsVissible = true
            appearance.delegate = self
            
            AppLocker.present(with: .deactive, and: appearance, withController: self)
        }else{
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController:HiddenNavBarNavigationController = storyboard.instantiateInitialViewController() as! HiddenNavBarNavigationController
            let firstPageVC:UIViewController = storyboard.instantiateViewController(withIdentifier: "firstPage") as UIViewController
            navigationController.viewControllers = [firstPageVC]
            self.present(navigationController, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func aboutMe(_ sender: Any) {
        let popupTransction =  MAAboutMeViewController(nibName: "MAAboutMeViewController", bundle: nil)
        self.presenter.presentationType = .popup
        popupTransction.titleDetail = "Hoe werkt het?"
        popupTransction.descriptionDetail = "Heb je al een indentiteit en ben je al ingelogd op de webshop? Open dan je indentiteit via de webshop en klik op 'Autoriseer apparaat' en vul de code in die op de Me App zichtbaar is."
        self.presenter.transitionType = nil
        self.presenter.dismissTransitionType = nil
        self.presenter.keyboardTranslationType = .compress
        self.customPresentViewController(self.presenter, viewController: popupTransction, animated: true, completion: nil)
    }
    
    func updateIndentity(){
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format:"accessToken == %@", UserShared.shared.currentUser.accessToken!)
        
        do{
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
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
    
    @IBAction func deletePasscode(_ sender: Any) {
        var appearance = ALAppearance()
        appearance.image = UIImage(named: "lock")!
        appearance.title = "Inlogcode uitzetten"
        appearance.subtitle = "Vul je inlogcode in"
        appearance.isSensorsEnabled = true
        appearance.cancelIsVissible = true
        appearance.delegate = self
        deletePasscode = true
        AppLocker.present(with: .deactive, and: appearance, withController: self)
    }
    
    
    // AppLocker Delegate
    func closePinCodeView(typeClose: typeClose) {
        updateIndentity()
        if typeClose == .change {
//            let parameters: Parameters = ["pin_code" : UserDefaults.standard.string(forKey: ALConstants.kPincode)!,
//                                          "old_pin_code" : UserShared.shared.currentUser.pinCode ?? ""]
//            RequestNewIndetity.updatePinCode(parameters: parameters, completion: { (response, statusCode) in
//                if statusCode == 401{
//                    //                    self.logOut()
//                }
//
//            }) { (error) in
//            }
            
            
        }else if typeClose == .delete{
            if !deletePasscode{
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController:HiddenNavBarNavigationController = storyboard.instantiateInitialViewController() as! HiddenNavBarNavigationController
                let firstPageVC:UIViewController = storyboard.instantiateViewController(withIdentifier: "firstPage") as UIViewController
                navigationController.viewControllers = [firstPageVC]
                self.present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    
}

