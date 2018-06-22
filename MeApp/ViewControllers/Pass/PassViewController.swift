//
//  PassViewController.swift
//  TestProject
//
//  Created by Tcacenco Daniel on 5/8/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Presentr

class PassViewController: MABaseViewController {
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var imageQR: UIImageView!
    @IBOutlet weak var voiceButton: VoiceButtonView!
    
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageQR.generateQRCode(from: "456,66")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showEmailToMe(_ sender: Any) {
        let popupTransction =  MAEmailForMeViewController(nibName: "MAEmailForMeViewController", bundle: nil)
        presenter.presentationType = .popup
        presenter.transitionType = nil
        presenter.dismissTransitionType = nil
        presenter.keyboardTranslationType = .compress
        customPresentViewController(presenter, viewController: popupTransction, animated: true, completion: nil)
    }
    
    @IBAction func showAmmount(_ sender: Any) {
        let popupTransction =  MAShareVaucherViewController(nibName: "MAShareVaucherViewController", bundle: nil)
        presenter.presentationType = .popup
        presenter.transitionType = nil
        presenter.dismissTransitionType = nil
        presenter.keyboardTranslationType = .compress
        customPresentViewController(presenter, viewController: popupTransction, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate
extension PassViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PassTableViewCell
        
        if indexPath.row == 0 {
            cell.companyTitle.text = "RMinds"
        }else if indexPath.row == 1{
            cell.companyTitle.text = "EBIntegrator"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let popupTransction =  TransactionViewController(nibName: "TransactionViewController", bundle: nil)
        dynamicSizePresenter.presentationType = .bottomHalf
        customPresentViewController(dynamicSizePresenter, viewController: popupTransction, animated: true, completion: nil)
    }
}

