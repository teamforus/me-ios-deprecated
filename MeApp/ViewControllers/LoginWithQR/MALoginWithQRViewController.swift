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
    var labels: [UILabel]!
    
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
        setupView()
    }
    
    fileprivate func setupView(){
        labels = [digit1UILabel, digit2UILabel, digit3UILabel, digit4UILabel, digit5UILabel, digit6UILabel]
        let screen = Device.screen
        switch screen {
        case .inches_5_8:
            constraintBottom.constant = 110
            break
        default:
            break
        }
        NotificationCenter.default.addObserver(self, selector: #selector(goToWalet), name: Notification.Name("TokenIsValidate"), object: nil)
        
        getCurrentUser()
        
        getPinCode()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToWalet"{
            let barVC = segue.destination as? TabBarController
            let nVC = barVC!.viewControllers![0] as? HiddenNavBarNavigationController
            let vc = nVC?.topViewController as? WalletViewController
            vc?.firstTimeEnter = true
        }
    }
}

extension MALoginWithQRViewController{
    
    fileprivate func getPinCode(){
        if reachability.connection != .none{
            AuthorizationCodeRequest.createAuthorizationCode(completion: { (response, statusCode) in
                if response.authCode != nil{
                    self.response = response
                    let stringCode: String = "\(response.authCode!)"
                    if stringCode.count == 6{
                        var counter: Int = 0
                        self.labels.forEach({ (label) in
                            label.text = String(stringCode[counter])
                            counter += 1
                        })
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
                    self.saveNewIdentityByAccessToken(primaryEmail: "", accessToken: self.response.accessTokenCode, givenName: "", familyName: "")
                    self.getCurrentUserByToken(accessToken: self.response.accessTokenCode)
                    self.performSegue(withIdentifier: "goToWalet", sender: nil)
                }
            }
        }) { (error) in
            AlertController.showError(vc:self)
        }
    }
}
