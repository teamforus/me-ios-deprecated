//
//  MATextViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/20/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MATextViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var textUITextView: UITextView!
    @IBOutlet weak var selectedCategory: ShadowButton!
    @IBOutlet weak var selectedType: ShadowButton!
    @IBOutlet weak var editUIButton: UIButton!
    @IBOutlet weak var clearUIButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textUITextView.layer.cornerRadius = 6
        NotificationCenter.default.addObserver(self, selector: #selector(setSelectedCategoryType), name: Notification.Name("SETSELECTEDCATEGORYTYPE"), object: nil)
        
    }
    
    @objc func setSelectedCategoryType(){
        selectedCategory.setTitle(UserDefaults.standard.string(forKey: "category"), for: .normal)
        selectedType.setTitle(UserDefaults.standard.string(forKey: "type"), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func submit(_ sender: Any) {
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
