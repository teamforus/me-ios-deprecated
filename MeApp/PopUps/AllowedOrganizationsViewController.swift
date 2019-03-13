//
//  AllowedOrganizationsViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 3/13/19.
//  Copyright © 2019 Foundation Forus. All rights reserved.
//

import UIKit

protocol AllowedOrganizationsViewControllerDelegate: class {
    func didSelectAllowedOrganization(organization: AllowedOrganizations)
}

class AllowedOrganizationsViewController: UIViewController {
    var allowedOrganizations: [AllowedOrganizations]!
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: AllowedOrganizationsViewControllerDelegate!
    var selectedOrganizations: AllowedOrganizations?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAnimate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.register(UINib(nibName: "OrganizationTableViewCell", bundle: nil), forCellReuseIdentifier: "OrganizationTableViewCell")
        didCalculateTableViewHeight()
        tableView.reloadData()
    }
    
    
    @IBAction func close(_ sender: Any) {
        self.removeAnimate()
    }

}

extension AllowedOrganizationsViewController{
    
    func didCalculateTableViewHeight(){
        var frameTableView = tableView.frame
        frameTableView.size.height = CGFloat(91 * allowedOrganizations.count)
        tableView.frame = frameTableView
    }
}

extension AllowedOrganizationsViewController: UITableViewDelegate, UITableViewDataSource, OrganizationTableViewCellDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allowedOrganizations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrganizationTableViewCell", for: indexPath) as! OrganizationTableViewCell
        let allowedOrganization = allowedOrganizations[indexPath.row]
        cell.allowedOrganization = allowedOrganization
        cell.delegate = self
        if allowedOrganization.id == selectedOrganizations?.id{
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func didSelectAllowedOrganization(organization: AllowedOrganizations) {
        delegate.didSelectAllowedOrganization(organization: organization)
        self.removeAnimate()
    }
    
    func selectedOrganization(organization: Organization) {
    }
}
