//
//  MATextViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/20/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Alamofire

class MATextViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var textUITextView: UITextView!
    @IBOutlet weak var selectedCategory: ShadowButton!
    @IBOutlet weak var selectedType: ShadowButton!
    @IBOutlet weak var editUIButton: UIButton!
    @IBOutlet weak var clearUIButton: UIButton!
    var recordType: RecordType!
    var recordCategory: RecordCategory!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func submit(_ sender: Any) {
        
        let parameters: Parameters = ["type" : recordType.key,
                                      "record_category_id" : recordCategory.id as Any,
                                      "value" : textUITextView.text]
        RecordsRequest.createRecord(parameters: parameters, completion: { (response) in
            NotificationCenter.default.post(name: Notification.Name("CLOSESLIDEPAGE"), object: nil)
        }) { (error) in
        }
    }
    
    @IBAction func edit(_ sender: Any) {
        if editUIButton.titleLabel?.text == "Confirm"{
            textUITextView.resignFirstResponder()
        }else {
            textUITextView.becomeFirstResponder()
        }
    }
    
    @IBAction func clear(_ sender: Any) {
        textUITextView.text = ""
        textUITextView.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count != 0{
            clearUIButton.isHidden = false
            editUIButton.setTitle("Confirm", for: .normal)
        }else {
            clearUIButton.isHidden = true
            editUIButton.setTitle("Edit", for: .normal)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textUITextView.text = ""
    }
    
}
