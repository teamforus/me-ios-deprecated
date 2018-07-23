//
//  MAChooseTypeViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/20/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import UICheckbox_Swift
import BWWalkthrough

class MAChooseTypeViewController: UIViewController, BWWalkthroughPage {
    
    
    @IBOutlet weak var selectedCategory: ShadowButton!
    @IBOutlet weak var emailUIButton: ShadowButton!
    @IBOutlet weak var primaryEmailUIButton: ShadowButton!
    @IBOutlet weak var givenNameUIButton: ShadowButton!
    @IBOutlet weak var childrenUIButton: ShadowButton!
    @IBOutlet weak var emailChekBox: UICheckbox!
    @IBOutlet weak var primaryEmailChekBox: UICheckbox!
    @IBOutlet weak var givenNameCheckBox: UICheckbox!
    @IBOutlet weak var childrenCheckBox: UICheckbox!
    var prevoiushButton: ShadowButton!
    var previusCheckBox: UICheckbox!
    var selectedChekBox: UICheckbox!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setSelectedCategory), name: Notification.Name("SETSELECTEDCATEGORY"), object: nil)
        
    }
    
    @objc func setSelectedCategory(){
        selectedCategory.setTitle(UserDefaults.standard.string(forKey: "category"), for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func walkthroughDidScroll(to: CGFloat, offset: CGFloat) {
        if prevoiushButton == nil {
            NotificationCenter.default.post(name: Notification.Name("DisableNextButton"), object: nil)
        }
    }
    
    @IBAction func selectType(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("EnableNextButton"), object: nil)
        if previusCheckBox != nil {
            previusCheckBox.isSelected = false
        }
        if sender as? UIButton == emailUIButton {
            UserDefaults.standard.set("E-mail", forKey: "type")
            emailUIButton.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8980392157, blue: 0.9725490196, alpha: 1)
            emailChekBox.isSelected = true
            previusCheckBox = emailChekBox
        }else if sender as? UIButton == primaryEmailUIButton{
            UserDefaults.standard.set("Primary E-mail", forKey: "type")
            primaryEmailUIButton.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8980392157, blue: 0.9725490196, alpha: 1)
            primaryEmailChekBox.isSelected = true
            previusCheckBox = primaryEmailChekBox
        }else if sender as? UIButton == givenNameUIButton{
            UserDefaults.standard.set("Given Name", forKey: "type")
            givenNameUIButton.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8980392157, blue: 0.9725490196, alpha: 1)
            givenNameCheckBox.isSelected = true
            previusCheckBox = givenNameCheckBox
        }else if sender as? UIButton == childrenUIButton{
            UserDefaults.standard.set("Children", forKey: "type")
            childrenUIButton.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8980392157, blue: 0.9725490196, alpha: 1)
            childrenCheckBox.isSelected = true
            previusCheckBox = childrenCheckBox
        }
        
        if prevoiushButton != nil{
            prevoiushButton.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        }
        prevoiushButton = sender as! ShadowButton
        NotificationCenter.default.post(name: Notification.Name("SETSELECTEDCATEGORYTYPE"), object: nil)
    }
}
