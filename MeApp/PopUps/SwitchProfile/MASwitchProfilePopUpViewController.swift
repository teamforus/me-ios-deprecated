//
//  MARegisterPopUpViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/31/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

protocol MASwitchProfilePopUpViewControllerDelegate:class {
    func switchProfile(_ controller: MASwitchProfilePopUpViewController, user: User)
}

import UIKit

class MASwitchProfilePopUpViewController: MABasePopUpViewController {
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: MASwitchProfilePopUpViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MASwitchProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "MAAddProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "MAAddProfileTableViewCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension MASwitchProfilePopUpViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell! = nil
        if indexPath.row == 2 {
            let cellAddProfile  = tableView.dequeueReusableCell(withIdentifier: "MAAddProfileTableViewCell", for: indexPath) as! MAAddProfileTableViewCell
            cell = cellAddProfile
            
        }else{
            let cellSwitchProfile  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MASwitchProfileTableViewCell
            cellSwitchProfile.profileImage.image = UIImage(named: "iconDigiD")
            if indexPath.row == 0{
                cellSwitchProfile.profileName.text = "Daniel Tcacenco"
            }else{
                cellSwitchProfile.profileName.text = "Gemeente Zuidhorn"
            }
            
            cell = cellSwitchProfile
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 59
        }
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 2  {
            let cell = tableView.cellForRow(at: indexPath) as! MASwitchProfileTableViewCell
            let alert = AlertController(title: cell.profileName.text, message: "Wold you like to switch to this account?", preferredStyle: .alert)
            alert.setTitleImage(UIImage(named: "iconDigiD"))
            
            let action = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action) -> Void in
                alert.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
                var user: User = User()
                user.name = cell.profileName.text
//                user.image = cell.profileImage.image
                self.delegate.switchProfile(self, user: user)
            }))
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        }
    }
}
