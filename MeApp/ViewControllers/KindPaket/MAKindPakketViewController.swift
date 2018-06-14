//
//  MAKindPakketViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/31/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Presentr

class MAKindPakketViewController: MABaseViewController, MAAllowViewControllerDelegate {
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()
    @IBOutlet weak var typeTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func chooseHour(_ sender: Any) {
        let popupTransction =  MAAllowViewController(nibName: "MAAllowViewController", bundle: nil)
        presenter.presentationType = .popup
        popupTransction.delegate = self
        presenter.transitionType = nil
        presenter.dismissTransitionType = nil
        presenter.keyboardTranslationType = .compress
        customPresentViewController(presenter, viewController: popupTransction, animated: true, completion: nil)
    }
    
    func chooseTypeTime(_ controller: MAAllowViewController, typeTime: String) {
        typeTimeLabel.text = typeTime
    }
    
}
