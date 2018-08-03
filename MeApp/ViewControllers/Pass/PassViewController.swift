//
//  PassViewController.swift
//  TestProject
//
//  Created by Tcacenco Daniel on 5/8/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Presentr
import SafariServices

class PassViewController: MABaseViewController, SFSafariViewControllerDelegate {
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var imageQR: UIImageView!
    @IBOutlet weak var voiceButton: VoiceButtonView!
    @IBOutlet weak var kindPaketQRView: UIView!
    @IBOutlet weak var emailMeButton: UIButton!
    @IBOutlet weak var smallerAmount: UIButton!
    @IBOutlet weak var qrView: UIView!
    
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kindPaketQRView.layer.cornerRadius = 9.0
        kindPaketQRView.layer.shadowColor = UIColor.black.cgColor
        kindPaketQRView.layer.shadowOffset = CGSize(width: 0, height: 5)
        kindPaketQRView.layer.shadowOpacity = 0.1
        kindPaketQRView.layer.shadowRadius = 10.0
        kindPaketQRView.layer.masksToBounds = false
        
        smallerAmount.layer.cornerRadius = 9.0
        emailMeButton.layer.cornerRadius = 9.0
        
        
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
//        let popupTransction =  MAShareVaucherViewController(nibName: "MAShareVaucherViewController", bundle: nil)
//        presenter.presentationType = .popup
//        presenter.transitionType = nil
//        presenter.dismissTransitionType = nil
//        presenter.keyboardTranslationType = .compress
//        customPresentViewController(presenter, viewController: popupTransction, animated: true, completion: nil)
        let safariVC = SFSafariViewController(url: URL(string: "https://www.zuidhorn.nl/kindpakket")!)
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
        
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
        let popOverVC = TransactionViewController(nibName: "TransactionViewController", bundle: nil)
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

