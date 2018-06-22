//
//  MAKindpakketCurrenciesViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/31/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Presentr

class MAKindpakketCurrenciesViewController: MABaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

// MARK: - UITableViewDelegate
extension MAKindpakketCurrenciesViewController: UITableViewDelegate, UITableViewDataSource{
    
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
