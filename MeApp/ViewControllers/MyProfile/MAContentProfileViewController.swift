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
import AssistantKit
import Crashlytics
import MessageUI

class MAContentProfileViewController: MABaseViewController, AppLockerDelegate {
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var closeUIButton: UIButton!
    var isCloseButtonHide: Bool!
    @IBOutlet weak var switchFaceID: UISwitch!
    @IBOutlet weak var faceIdImage: UIImageView!
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var supportEmailButton: UIButton!
    @IBOutlet weak var switchScannert: UISwitch!
    @IBOutlet weak var heightBottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var faceIdLabel: UILabel!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileEmailLabel: UILabel!
    @IBOutlet weak var passcodeLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var turnOnOffFaceId: CustomCornerUIView!
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
        self.getRecordList()
        switchFaceID.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
        if let thumbView =  (switchFaceID.subviews[0].subviews[3] as? UIImageView) {
            thumbView.transform = CGAffineTransform(scaleX:0.73, y: 0.73)
        }
        
        switchScannert.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
        if let thumbView =  (switchScannert.subviews[0].subviews[3] as? UIImageView) {
            thumbView.transform = CGAffineTransform(scaleX:0.73, y: 0.73)
        }
       
//        switchFaceID.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //        UserDefaults.standard.set("0000", forKey: ALConstants.kPincode)
        //        UserDefaults.standard.synchronize()
        //        updateIndentity()
    }
    
    @IBAction func crash(_ sender: Any) {
        Crashlytics.sharedInstance().crash()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.string(forKey: ALConstants.kPincode) == "" || UserDefaults.standard.string(forKey: ALConstants.kPincode) == nil{
            turnOffPascodeView.isHidden = true
            turnOnOffFaceId.isHidden = true
            passcodeLabel.text = "Create passcode".localized()
            heightButtonsView.constant = 130
            verticalSpacingFaceIdLogin.constant = 10
        }else{
            heightButtonsView.constant = 270
            verticalSpacingFaceIdLogin.constant = 82
            turnOffPascodeView.isHidden = false
            turnOnOffFaceId.isHidden = false
            passcodeLabel.text = "Change passcode".localized()
        }
        
        
        if UserDefaults.standard.bool(forKey: "isStartFromScanner"){
            switchScannert.isOn = true
        }else {
            switchScannert.isOn = false
        }
        
         self.layoutBottom()
        closeUIButton.isHidden = isCloseButtonHide ?? true
        if UserDefaults.standard.bool(forKey: "isWithTouchID"){
            switchFaceID.isOn = true
        }else {
            switchFaceID.isOn = false
        }
        
        if !faceIDAvailable(){
            faceIdImage.image = #imageLiteral(resourceName: "touchId")
            faceIdLabel.text = "Turn on Touch ID".localized()
        }
        let versionApp: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let buildAppNumber: AnyObject? = Bundle.main.infoDictionary?["CFBundleVersion"] as AnyObject
        
        appVersionLabel.text = (versionApp as? String)! + " - dev - " + (buildAppNumber as? String)!
//        CFBundleVersion
    }
    
    func getRecordList(){
        RecordsRequest.getRecordsList(completion: { (response, statusCode) in
            let mutableString = NSMutableString()
            for record in response{
                if (record as! Record).key == "given_name"{
                     mutableString.append((record as! Record).value)
                }else if (record as! Record).key == "primary_email" {
                    self.profileEmailLabel.text = (record as! Record).value
                }else if (record as! Record).key == "family_name" {
                    mutableString.append(" \((record as! Record).value ?? "")")
                }
            }
            self.profileNameLabel.text = mutableString as String
            
        }) { (error) in
            AlertController.showError(vc:self)
        }
    }
    
    // layout constrint
    
    func layoutBottom(){
       
        let screen = Device.screen
        switch screen {
        case .inches_4_0:
           // rect.size.height = 440
            break
        case .inches_4_7:
           // rect.size.height = 500
            break
        case .inches_5_5:
            self.heightBottomViewConstraint.constant = 280
            break
        case .inches_5_8:
           self.heightBottomViewConstraint.constant = 300
            break
        default:
            break
            
        }
        
    }
    
    func faceIDAvailable() -> Bool {
        if #available(iOS 11.0, *) {
            let context = LAContext()
            return (context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: nil) && context.biometryType == .faceID)
        }
        return false
    }
    
    @IBAction func feedBack(_ sender: Any) {
        let alert: UIAlertController
        alert = UIAlertController(title: "", message: "Would you like to send us your feedback by e-mail?".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm".localized(), style: .default, handler: { (action) in
            if MFMailComposeViewController.canSendMail() {
                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = self
                composeVC.setToRecipients(["feedback@forus.io"])
                composeVC.setSubject("My feedback about the Me app".localized())
                composeVC.setMessageBody("", isHTML: false)
                self.present(composeVC, animated: true, completion: nil)
            }else{
                AlertController.showWarning(withText: "Mail services are not available".localized(), vc: self)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .default, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func checkStartFromScreen(_ sender: UISwitch) {
        if sender.isOn{
            UserDefaults.standard.set(true, forKey: "isStartFromScanner")
        }else{
            UserDefaults.standard.set(false, forKey: "isStartFromScanner")
        }
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
                appearance.title = "Change passcode".localized()
                appearance.subtitle = "Enter your old code".localized()
                appearance.isSensorsEnabled = true
                appearance.cancelIsVissible = true
                appearance.delegate = self
                
                AppLocker.present(with: .change, and: appearance, withController: self)
            }else{
//                UserDefaults.standard.set("", forKey: ALConstants.kPincode)
                var appearance = ALAppearance()
                appearance.image = UIImage(named: "lock")!
                appearance.title = "Login code".localized()
                appearance.subtitle = "Enter a new login code".localized()
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
            appearance.title = "Login code".localized()
            appearance.subtitle = "Enter your login code".localized()
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
        popupTransction.titleDetail = "About Me".localized()
        popupTransction.descriptionDetail = "With the Me you can create an identity, receive and use your vouchers. For more information please visit our website — https://zuidhorn.forus.io".localized()
        self.presenter.transitionType = nil
        self.presenter.dismissTransitionType = nil
        self.presenter.dismissOnTap = true
         presenter.dismissAnimated = true
//        self.presenter.keyboardTranslationType = .compress
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
        appearance.title = "Turn off login code".localized()
        appearance.subtitle = "Enter login code".localized()
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

extension MAContentProfileViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

