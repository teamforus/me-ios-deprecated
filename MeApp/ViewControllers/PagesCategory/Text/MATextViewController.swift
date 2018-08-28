//
//  MATextViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/20/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift
import Reachability

class MATextViewController: MABaseViewController, UITextViewDelegate {
    @IBOutlet weak var textUITextView: UITextView!
    @IBOutlet weak var selectedCategory: ShadowButton!
    @IBOutlet weak var selectedType: ShadowButton!
    @IBOutlet weak var editUIButton: UIButton!
    @IBOutlet weak var clearUIButton: UIButton!
    var recordType: RecordType!
    let reachablity = Reachability()!
    var recordCategory: RecordCategory!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldShowToolbarPlaceholder = false
        textUITextView.layer.cornerRadius = 6
        NotificationCenter.default.addObserver(self, selector: #selector(setSelectedCategoryType), name: Notification.Name("SETSELECTEDCATEGORYTYPE"), object: nil)
    }
    
    @objc func setSelectedCategoryType(){
        if let recordCategory = UserDefaults.standard.value(forKey: "category") as? NSData {
            self.recordCategory = try? PropertyListDecoder().decode(RecordCategory.self, from: recordCategory as Data)
            selectedCategory.setTitle(self.recordCategory?.name, for: .normal)
        }
        if let recordType = UserDefaults.standard.value(forKey: "type") as? NSData {
            self.recordType = try? PropertyListDecoder().decode(RecordType.self, from: recordType as Data)
            selectedType.setTitle(self.recordType?.name, for: .normal)
            if self.recordType.type == "number" {
                self.textUITextView.keyboardType = .numberPad
            }
            
            if self.recordType.name.contains("E-mail"){
                self.textUITextView.keyboardType = .emailAddress
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func submit(_ sender: Any) {
        if self.recordType.name.contains("E-mail"){
            if !Validation.validateEmail(textUITextView.text) {
                AlertController.showWarning(withText: "E-mail is not valid")
                return
            }
        }
        if reachablity.connection != .none{
            let parameters: Parameters = ["type" : recordType.key,
                                          "value" : textUITextView.text]
            RecordsRequest.createRecord(parameters: parameters, completion: { (response, statusCode) in
                if statusCode == 401{
                    self.logOut()
                    return
                }
                NotificationCenter.default.post(name: Notification.Name("CLOSESLIDEPAGE"), object: nil)
            }) { (error) in
                AlertController.showError()
            }
        }else {
            AlertController.showInternetUnable()
        }
    }
    
    @IBAction func edit(_ sender: Any) {
        //        if editUIButton.titleLabel?.text == "Confirm"{
        //            textUITextView.resignFirstResponder()
        //        }else {
        //            textUITextView.becomeFirstResponder()
        //        }
    }
    
    @IBAction func clear(_ sender: Any) {
        textUITextView.text = ""
        textUITextView.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count != 0{
            clearUIButton.isHidden = false
//            editUIButton.setTitle("Confirm", for: .normal)
        }else {
            clearUIButton.isHidden = true
//            editUIButton.setTitle("Edit", for: .normal)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textUITextView.text = ""
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
}
