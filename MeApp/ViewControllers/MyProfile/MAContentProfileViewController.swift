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
import PWSwitch




class MAContentProfileViewController: MABaseViewController, AppLockerDelegate {
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var closeUIButton: UIButton!
    var isCloseButtonHide: Bool!
    @IBOutlet weak var switchFaceID: PWSwitch!
    @IBOutlet weak var enableCrashAddress: PWSwitch!
    @IBOutlet weak var faceIdImage: UIImageView!
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var chooseOrganizationButton: UIButton!
    
    @IBOutlet weak var supportEmailButton: UIButton!
    @IBOutlet weak var switchScannert: PWSwitch!
    @IBOutlet weak var heightBottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var faceIdLabel: UILabel!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileEmailLabel: UILabel!
    var organization: Organization!
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
    }
    
    @IBAction func crash(_ sender: Any) {
        Crashlytics.sharedInstance().crash()
    }
    
    func didUpdateButtonStackView(isHiddeButtons: Bool, heigthConstant: CGFloat, verticalConstant: CGFloat){
        heightButtonsView.constant = heigthConstant
        verticalSpacingFaceIdLogin.constant = verticalConstant
        turnOffPascodeView.isHidden = isHiddeButtons
        turnOnOffFaceId.isHidden = isHiddeButtons
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let popOverVC = PopUpOrganizationsViewController(nibName: "PopUpOrganizationsViewController", bundle: nil)
        popOverVC.delegate = self
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 102)
        self.view.addSubview(popOverVC.view)
        if UserDefaults.standard.string(forKey: ALConstants.kPincode) == "" || UserDefaults.standard.string(forKey: ALConstants.kPincode) == nil{
            passcodeLabel.text = "Create passcode".localized()
            self.didUpdateButtonStackView(isHiddeButtons: true, heigthConstant: 130, verticalConstant: 10)
        }else{
            passcodeLabel.text = "Change passcode".localized()
            self.didUpdateButtonStackView(isHiddeButtons: false, heigthConstant: 249, verticalConstant: 66)
        }
        
       
        if UserDefaults.standard.bool(forKey: "isStartFromScanner"){
            switchScannert.setOn(true, animated: true)
        }else {
            switchScannert.setOn(false, animated: true)
        }
        
        self.layoutBottom()
        closeUIButton.isHidden = isCloseButtonHide ?? true
        
        if !devicePasscodeSet(){
            turnOnOffFaceId.isHidden = true
            heightButtonsView.constant = 200
        }
        
        if UserDefaults.standard.bool(forKey: "isWithTouchID"){
            switchFaceID.setOn(true, animated: true)
        }else {
            switchFaceID.setOn(false, animated: true)
        }
        
        if UserDefaults.standard.bool(forKey: "ISENABLESENDADDRESS"){
            enableCrashAddress.setOn(true, animated: true)
        }else {
            enableCrashAddress.setOn(false, animated: true)
        }
        
        if !faceIDAvailable(){
            faceIdImage.image = #imageLiteral(resourceName: "touchId")
            faceIdLabel.text = "Turn on Touch ID".localized()
        }
        let versionApp: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let buildAppNumber: AnyObject? = Bundle.main.infoDictionary?["CFBundleVersion"] as AnyObject
        
        appVersionLabel.text = (versionApp as? String)! + " - dev - " + (buildAppNumber as? String)!
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
            self.heightBottomViewConstraint.constant = 260
            break
        case .inches_5_8:
            self.heightBottomViewConstraint.constant = 210
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
    
    private func devicePasscodeSet() -> Bool {
        //checks to see if devices (not apps) passcode has been set
        return LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
    }
    
    
    @IBAction func feedBack(_ sender: Any) {
        let alert: UIAlertController
        alert = UIAlertController(title: "Support", message: "Would you like to send us your feedback by e-mail?".localized(), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .default, handler: { (action) in
        }))
        
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
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkStartFromScreen(_ sender: PWSwitch) {
        if sender.on{
            UserDefaults.standard.set(true, forKey: "isStartFromScanner")
        }else{
            UserDefaults.standard.set(false, forKey: "isStartFromScanner")
        }
    }
    
    @IBAction func faceIdEnable(_ sender: PWSwitch) {
        if sender.on{
            UserDefaults.standard.set(true, forKey: "isWithTouchID")
        }else{
            UserDefaults.standard.set(false, forKey: "isWithTouchID")
        }
    }
    
    @IBAction func crashReportAddressEnable(_ sender: PWSwitch) {
        if sender.on{
            UserDefaults.standard.set(true, forKey: "ISENABLESENDADDRESS")
        }else{
            UserDefaults.standard.set(false, forKey: "ISENABLESENDADDRESS")
        }
    }
    
    
    func didChooseAppLocker(title: String, subTitle: String, mode: ALMode){
        var appearance = ALAppearance()
        appearance.image = UIImage(named: "lock")!
        appearance.title = title
        appearance.subtitle = subTitle
        appearance.isSensorsEnabled = true
        appearance.cancelIsVissible = true
        appearance.delegate = self
        
        AppLocker.present(with: mode, and: appearance, withController: self)
    }
    
    @IBAction func editPasscode(_ sender: Any) {
        if reachability.connection != .none{
            if UserDefaults.standard.string(forKey: ALConstants.kPincode) != "" && UserDefaults.standard.string(forKey: ALConstants.kPincode) != nil{
                didChooseAppLocker(title: "Change passcode".localized(), subTitle: "Enter your old code".localized(), mode: .change)
            }else{
                didChooseAppLocker(title: "Login code".localized(), subTitle: "Enter a new login code".localized(), mode: .create)
            }
        }else {
            AlertController.showInternetUnable(vc: self)
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        self.logOutProfile()
    }
    
    func logOutProfile(){
        if UserDefaults.standard.string(forKey: ALConstants.kPincode) != "" && UserDefaults.standard.string(forKey: ALConstants.kPincode) != nil{
            didChooseAppLocker(title: "Login code".localized(), subTitle: "Enter your login code".localized(), mode: .deactive)
        }else{
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController:HiddenNavBarNavigationController = storyboard.instantiateInitialViewController() as! HiddenNavBarNavigationController
            let firstPageVC:UIViewController = storyboard.instantiateViewController(withIdentifier: "firstPage") as UIViewController
            navigationController.viewControllers = [firstPageVC]
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func aboutMe(_ sender: Any) {
        let vc =  MAAboutMeViewController(nibName: "MAAboutMeViewController", bundle: nil)
        self.present(vc, animated: true, completion: nil)
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
        deletePasscode = true
        didChooseAppLocker(title: "Turn off login code".localized(), subTitle: "Enter login code".localized(), mode: .deactive)
    }
    
    // AppLocker Delegate
    func closePinCodeView(typeClose: typeClose) {
        updateIndentity()
        if typeClose == .delete{
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

extension MAContentProfileViewController: OrganizationListDelegate{
    func selectedOrganization(organization: Organization) {
        self.organization = organization
    }
}



extension UIViewController{
    func errorMessageForLAErrorCode( errorCode:Int ) -> String{
        
        var message = ""
        
        switch errorCode {
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.touchIDLockout.rawValue:
            message = "Too many failed attempts."
            
        case LAError.touchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
            
        }
        
        return message
        
    }
}
