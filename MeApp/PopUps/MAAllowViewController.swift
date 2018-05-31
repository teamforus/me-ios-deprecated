//
//  MAAllowViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/22/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//
protocol MAAllowViewControllerDelegate:class {
    func chooseTypeTime(_ controller: MAAllowViewController, typeTime:String)
}

import UIKit

class MAAllowViewController: MABasePopUpViewController {
    
    @IBOutlet weak var tableView: UITableView!
   weak var delegate: MAAllowViewControllerDelegate!
    var previousIndexPath: IndexPath!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MAAllowTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  
}

// MARK: - UITableViewDelegate
extension MAAllowViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MAAllowTableViewCell
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.typeTime.text = "1 hour"
        } else if indexPath.row == 1{
            cell.typeTime.text = "1 day"
        }else if indexPath.row == 2 {
            cell.typeTime.text = "1 week"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if previousIndexPath != nil {
            if let cell = tableView.cellForRow(at: previousIndexPath) {
                cell.accessoryType = .none
            }
        }
        previousIndexPath = indexPath
        let cell = tableView.cellForRow(at: indexPath) as! MAAllowTableViewCell
            cell.accessoryType = .checkmark
            delegate.chooseTypeTime(self, typeTime: cell.typeTime.text! )
    }
    
    
}
