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
            passcodeLabel.text = NSLocalizedString("Create passcode", comment: "")
            heightButtonsView.constant = 124
            verticalSpacingFaceIdLogin.constant = 10
        }else{
            heightButtonsView.constant = 194
            verticalSpacingFaceIdLogin.constant = 82
            turnOffPascodeView.isHidden = false
            passcodeLabel.text = NSLocalizedString("Change passcode", comment: "")
        }
        
        
        closeUIButton.isHidden = isCloseButtonHide ?? true
        if UserDefaults.standard.bool(forKey: "isWithTouchID"){
            switchFaceID.isOn = true
        }else {
            switchFaceID.isOn = false
        }
        
        if !faceIDAvailable(){
            faceIdImage.image = #imageLiteral(resourceName: "touchId")
            faceIdLabel.text = NSLocalizedString("Turn on Touch ID", comment: "")
        }
        if UserShared.shared.currentUser.primaryEmail != nil{
            profileNameLabel.text = "\(UserShared.shared.currentUser.firstName!) \(UserShared.shared.currentUser.lastName!)"
        }
        profileEmailLabel.text = UserShared.shared.currentUser.primaryEmail
        let versionApp: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let buildAppNumber: AnyObject? = Bundle.main.infoDictionary?["CFBundleVersion"] as AnyObject
        
        appVersionLabel.text = (versionApp as? String)! + " - dev - " + (buildAppNumber as? String)!
//        CFBundleVersion
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
            if let thumbView =  ((sender as! UISwitch).subviews[0].subviews[3] as? UIImageView) {
                thumbView.transform = CGAffineTransform(scaleX:0.8, y: 0.8)
            }
            UserDefaults.standard.set(true, forKey: "isWithTouchID")
        }else{
            UserDefaults.standard.set(false, forKey: "isWithTouchID")
            if let thumbView =  ((sender as! UISwitch).subviews[0].subviews[3] as? UIImageView) {
                thumbView.transform = CGAffineTransform(scaleX:1.0, y: 1.0)
            }
        }
        
    }
    
    @IBAction func editPasscode(_ sender: Any) {
        if reachability.connection != .none{
            if UserDefaults.standard.string(forKey: ALConstants.kPincode) != "" && UserDefaults.standard.string(forKey: ALConstants.kPincode) != nil{
                var appearance = ALAppearance()
                appearance.image = UIImage(named: "lock")!
                appearance.title = NSLocalizedString("Change passcode", comment: "")
                appearance.subtitle = NSLocalizedString("Enter your old code", comment: "")
                appearance.isSensorsEnabled = true
                appearance.cancelIsVissible = true
                appearance.delegate = self
                
                AppLocker.present(with: .change, and: appearance, withController: self)
            }else{
//                UserDefaults.standard.set("", forKey: ALConstants.kPincode)
                var appearance = ALAppearance()
                appearance.image = UIImage(named: "lock")!
                appearance.title = NSLocalizedString("Login code", comment: "")
                appearance.subtitle = NSLocalizedString("Enter a new login code", comment: "")
                appearance.isSensorsEnabled = true
                appearance.cancelIsVissible = true
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
            appearance.title = NSLocalizedString("Login code", comment: "")
            appearance.subtitle = NSLocalizedString("Set up the login code", comment: "")
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
        popupTransction.titleDetail = NSLocalizedString("About Me", comment: "")
        popupTransction.descriptionDetail = NSLocalizedString("With the Me App you can create an identity, receive and use your vouchers. For more information please visit our website — https://zuidhorn.forus.io", comment: "")
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
        appearance.title = NSLocalizedString("Turn off login code", comment: "")
        appearance.subtitle = NSLocalizedString("Enter login code", comment: "")
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
                let firstPageVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "firstPage") as UIViewController
                navigationController.viewControllers = [firstPageVC]
                self.present(navigationController, animated: true, completion: nil)
            }
        }
    }
}

