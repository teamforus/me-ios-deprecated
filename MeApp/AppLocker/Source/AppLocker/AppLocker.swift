//
//  AppALConstants.swift
//  AppLocker
//
//  Created by Oleg Ryasnoy on 07.07.17.
//  Copyright © 2017 Oleg Ryasnoy. All rights reserved.
//

import UIKit
import AudioToolbox
import LocalAuthentication

protocol AppLockerDelegate: class {
    func closePinCodeView(typeClose: typeClose)
}

enum typeClose: Int {
    case cancel = 0
    case create = 1
    case validate = 2
    case delete = 3
    case change = 4
}

public enum ALConstants {
    static let nibName = "AppLocker"
    static let kPincode = "pinCode" // Key for saving pincode to UserDefaults
    static let kLocalizedReason = "Unlock with sensor" // Your message when sensors must be shown
    static let duration = 0.3 // Duration of indicator filling
    static let maxPinLength = 4
    
    enum button: Int {
        case delete = 1000
        case cancel = 1001
    }
}

public struct ALAppearance { // The structure used to display the controller
    public var title: String?
    public var subtitle: String?
    public var image: UIImage?
    public var color: UIColor?
    public var isSensorsEnabled: Bool?
    public var cancelIsVissible: Bool?
    weak var delegate: AppLockerDelegate!
    public init() {}
}

public enum ALMode { // Modes for AppLocker
    case validate
    case change
    case deactive
    case create
}

public class AppLocker: UIViewController {
    
    // MARK: - Top view
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var submessageLabel: UILabel!
    @IBOutlet var pinIndicators: [Indicator]!
    weak var delegate: AppLockerDelegate!
    @IBOutlet weak var cancelButton: Button!
    
    // MARK: - Pincode
    private let context = LAContext()
    private var pin = "" // Entered pincode
    private var reservedPin = "" // Reserve pincode for confirm
    private var isFirstCreationStep = true
    private var savedPin: String? {
        get {
            return UserDefaults.standard.string(forKey: ALConstants.kPincode)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ALConstants.kPincode)
        }
    }
    
    fileprivate var mode: ALMode? {
        didSet {
            let mode = self.mode ?? .validate
            switch mode {
            case .create:
                messageLabel.text = "Login code".localized() // Your message for create mode
                submessageLabel.text = NSLocalizedString("Enter a new login code", comment: "") // Your message for create mode // Your submessage for create mode
            case .change:
                messageLabel.text = NSLocalizedString("Enter login code", comment: "") // Your submessage for change mode
            case .deactive:
                messageLabel.text = NSLocalizedString("Turn off login code", comment: "") // Your submessage for deactive mode
            case .validate:
                messageLabel.text = NSLocalizedString("Enter login code", comment: "") // Your submessage for validate mode
                isFirstCreationStep = false
            }
        }
    }
    
    private func precreateSettings () { // Precreate settings for change mode
        mode = .create
        clearView()
    }
    
    private func drawing(isNeedClear: Bool, tag: Int? = nil) { // Fill or cancel fill for indicators
        let results = pinIndicators.filter { $0.isNeedClear == isNeedClear }
        let pinView = isNeedClear ? results.last : results.first
        pinView?.isNeedClear = !isNeedClear
        
        UIView.animate(withDuration: ALConstants.duration, animations: {
            pinView?.backgroundColor = isNeedClear ? .clear : #colorLiteral(red: 0.2078431373, green: 0.3921568627, blue: 0.9764705882, alpha: 1)
        }) { _ in
            isNeedClear ? self.pin = String(self.pin.dropLast()) : self.pincodeChecker(tag ?? -1)
        }
    }
    
    private func pincodeChecker(_ pinNumber: Int) {
        if pin.count < ALConstants.maxPinLength {
            pin.append("\(pinNumber)")
            if pin.count == ALConstants.maxPinLength {
                switch mode ?? .validate {
                case .create:
                    createModeAction()
                case .change:
                    changeModeAction()
                case .deactive:
                    deactiveModeAction()
                case .validate:
                    validateModeAction()
                }
            }
        }
    }
    
    // MARK: - Modes
    private func createModeAction() {
        if isFirstCreationStep {
            isFirstCreationStep = false
            reservedPin = pin
            clearView()
            messageLabel.text = NSLocalizedString("Confirm the code", comment: "")
        } else {
            confirmPin()
        }
    }
    
    private func changeModeAction() {
        pin == savedPin ? precreateSettings() : incorrectPinAnimation()
    }
    
    private func deactiveModeAction() {
        pin == savedPin ? removePin() : incorrectPinAnimation()
    }
    
    private func validateModeAction() {
        UserDefaults.standard.set(true, forKey: "PINCODEENABLED")
        pin == savedPin ? dismiss(animated: true, completion: nil) : incorrectPinAnimation()
        delegate.closePinCodeView(typeClose: .validate)
    }
    
    private func removePin() {
        UserDefaults.standard.set(false, forKey: "PINCODEENABLED")
        UserDefaults.standard.removeObject(forKey: ALConstants.kPincode)
        dismiss(animated: true, completion: nil)
        delegate.closePinCodeView(typeClose: .delete)
        
    }
    
    private func confirmPin() {
        UserDefaults.standard.set(true, forKey: "PINCODEENABLED")
        if pin == reservedPin {
            savedPin = pin
            dismiss(animated: true, completion: nil)
            delegate.closePinCodeView(typeClose: .create)
        } else {
            incorrectPinAnimation()
        }
    }
    
    private func incorrectPinAnimation() {
        pinIndicators.forEach { view in
            
            view.shake(delegate: self)
            view.backgroundColor = .red
            self.photoImageView.image = UIImage(named: "lockError")
            if self.isFirstCreationStep == false {
                submessageLabel.text = NSLocalizedString("Codes don't match. Please try again", comment: "")
            }else{
                submessageLabel.text = NSLocalizedString("Wrong passcode, please try again", comment: "")
            }
            
        }
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    fileprivate func clearView() {
        pin = ""
        pinIndicators.forEach { view in
            view.isNeedClear = false
            UIView.animate(withDuration: ALConstants.duration, animations: {
                view.backgroundColor = .clear
            })
        }
    }
    
    // MARK: - Touch ID / Face ID
    fileprivate func checkSensors() {
        guard mode == .validate else {return}
        
        var policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics // iOS 8+ users with Biometric and Custom (Fallback button) verification
        
        // Depending the iOS version we'll need to choose the policy we are able to use
        if #available(iOS 9.0, *) {
            // iOS 9+ users with Biometric and Passcode verification
            policy = .deviceOwnerAuthentication
        }
        
        var err: NSError?
        // Check if the user is able to use the policy we've selected previously
        guard context.canEvaluatePolicy(policy, error: &err) else {return}
        
        // The user is able to use his/her Touch ID / Face ID 👍
        context.evaluatePolicy(policy, localizedReason: ALConstants.kLocalizedReason, reply: {  success, error in
            if success {
                self.dismiss(animated: true, completion: nil)
                self.delegate.closePinCodeView(typeClose: .validate)
            }
        })
    }
    
    // MARK: - Keyboard
    @IBAction func keyboardPressed(_ sender: UIButton) {
        switch sender.tag {
        case ALConstants.button.delete.rawValue:
            drawing(isNeedClear: true)
        case ALConstants.button.cancel.rawValue:
            clearView()
            self.dismiss(animated: true, completion: nil)
            delegate.closePinCodeView(typeClose: .cancel)
        default:
            drawing(isNeedClear: false, tag: sender.tag)
        }
    }
    
}

// MARK: - CAAnimationDelegate
extension AppLocker: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        clearView()
    }
}

// MARK: - Present
public extension AppLocker {
    // Present AppLocker
    class func present(with mode: ALMode, and config: ALAppearance? = nil, withController: UIViewController) {
        
        guard let _ = UIApplication.shared.keyWindow?.rootViewController,
            
            let locker = Bundle(for: self.classForCoder()).loadNibNamed(ALConstants.nibName, owner: self, options: nil)?.first as? AppLocker else {
                return
        }
        //    if mode == .validate {
        //        if locker.savedPin == "" || locker.savedPin == nil  {
        //            return
        //        }
        //    }
        if (config?.cancelIsVissible)!{
            locker.cancelButton.isHidden = false
        }else{
            locker.cancelButton.isHidden = true
        }
        locker.messageLabel.text = config?.title ?? ""
        locker.submessageLabel.text = config?.subtitle ?? ""
        locker.view.backgroundColor = config?.color ?? .black
        locker.mode = mode
        locker.delegate = config?.delegate
        if config?.isSensorsEnabled ?? false {
            if UserDefaults.standard.bool(forKey: "isWithTouchID"){
                locker.checkSensors()
            }
        }
        
        if let image = config?.image {
            locker.photoImageView.image = image
        } else {
            locker.photoImageView.isHidden = true
        }
        
        withController.present(locker, animated: true, completion: nil)
    }
}
