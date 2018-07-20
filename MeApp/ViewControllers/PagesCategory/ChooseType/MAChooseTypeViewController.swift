//
//  MAChooseTypeViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/20/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import UICheckbox_Swift

class MAChooseTypeViewController: UIViewController {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func selectType(_ sender: Any) {
       if previusCheckBox != nil {
            previusCheckBox.isSelected = false
        }
        if sender as? UIButton == emailUIButton {
            emailUIButton.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8980392157, blue: 0.9725490196, alpha: 1)
            emailChekBox.isSelected = true
            previusCheckBox = emailChekBox
        }else if sender as? UIButton == primaryEmailUIButton{
            primaryEmailUIButton.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8980392157, blue: 0.9725490196, alpha: 1)
            primaryEmailChekBox.isSelected = true
            previusCheckBox = primaryEmailChekBox
        }else if sender as? UIButton == givenNameUIButton{
            givenNameUIButton.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8980392157, blue: 0.9725490196, alpha: 1)
            givenNameCheckBox.isSelected = true
            previusCheckBox = givenNameCheckBox
        }else if sender as? UIButton == childrenUIButton{
            childrenUIButton.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8980392157, blue: 0.9725490196, alpha: 1)
            childrenCheckBox.isSelected = true
            previusCheckBox = childrenCheckBox
        }
        
        if prevoiushButton != nil{
            prevoiushButton.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        }
        prevoiushButton = sender as! ShadowButton
    }
}
