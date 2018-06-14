//
//  MAOfficeViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/23/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import DropDown

class MAOfficeViewController: MABaseViewController {
    
    @IBOutlet weak var dropDownButton: UIButton!
    let chooseArticleDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCenteredDropDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
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
    }
    
    
    @IBAction func showDropDown(_ sender: Any) {
        chooseArticleDropDown.show()
    }
    
}
