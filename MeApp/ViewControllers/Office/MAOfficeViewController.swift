//
//  MAOfficeViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/23/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import DropDown

class MAOfficeViewController: UIViewController {
    
    @IBOutlet weak var dropDownButton: UIButton!
    let chooseArticleDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCenteredDropDown()
    }
    
    
    func setupCenteredDropDown() {
        chooseArticleDropDown.anchorView = dropDownButton
        chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y: dropDownButton.bounds.height)
        chooseArticleDropDown.dataSource = [
            "Gebouw"
        ]
        
        chooseArticleDropDown.selectionAction = { [weak self] (index, item) in
            self?.dropDownButton.setTitle(item, for: .normal)
        }
        
        chooseArticleDropDown.selectionAction = { [weak self] (indices, items) in
            print("Muti selection action called with: \(items)")
            if items.isEmpty {
                self?.dropDownButton.setTitle("", for: .normal)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func showDropDown(_ sender: Any) {
        chooseArticleDropDown.show()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
