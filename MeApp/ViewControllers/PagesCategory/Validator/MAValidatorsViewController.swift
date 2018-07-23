//
//  MAValidatorsViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/23/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MAValidatorsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension MAValidatorsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MAValidatorCellTableViewCell
        
        if indexPath.row == 0{
            cell.nameValidator.text = "DigiD"
            cell.descriptionValidator.text = "Open DigiD app"
        }else if indexPath.row == 1 {
            cell.nameValidator.text = "Gemeente Zuidhorn"
            cell.descriptionValidator.text = "Automatische validatie"
        }else if indexPath.row == 2 {
            cell.nameValidator.text = "Gemeente Zuidhorn"
            cell.descriptionValidator.text = "Verzoek validatie"
        }
        
        return cell
    }
}
