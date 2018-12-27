//
//  PopUpOrganizationsViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 12/19/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit

protocol OrganizationListDelegate: class {
    func selectedOrganization(organization: Organization)
}

class PopUpOrganizationsViewController: UIViewController {
    var organizations: NSMutableArray! = NSMutableArray()
    weak var delegate: OrganizationListDelegate!
    @IBOutlet weak var tableView: UITableView!
    let screenSize: CGRect = UIScreen.main.bounds
    var dropDownIsVisible: Bool = false
    @IBOutlet weak var arrowImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "OrganizationTableViewCell", bundle: nil), forCellReuseIdentifier: "OrganizationTableViewCell")
        self.getOrganizationList()
    }
    
    func getOrganizationList(){
        OrganizationRequest.reqeustOrganizations(completion: { (organizations, statusCode) in
            self.organizations.removeAllObjects()
            self.organizations = organizations
            self.tableView.reloadData()
        }) { (error) in }
    }
    
    func animateOrganizationList(){
        if !dropDownIsVisible{
            didExpandView(screenHeight: self.screenSize.height)
            dropDownIsVisible = true
        }else{
            didExpandView(screenHeight: 102)
            dropDownIsVisible = false
        }
    }
    
    func didExpandView(screenHeight: CGFloat){
        UIView.animate(withDuration: 0.4) {
            self.arrowImageView.layer.transform = CATransform3DRotate(CATransform3DIdentity, CGFloat(180 * Double.pi / 180), 0, 0, 0)
            var frame = self.view.frame
            frame.size.height = 102
            self.view.frame = frame
            self.viewWillLayoutSubviews()
        }
    }
    
    @IBAction func showOrganizationList(_ sender: Any) {
        animateOrganizationList()
    }
}

extension PopUpOrganizationsViewController: UITableViewDelegate, UITableViewDataSource, OrganizationTableViewCellDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organizations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrganizationTableViewCell", for: indexPath) as! OrganizationTableViewCell
        cell.organization = organizations[indexPath.row] as? Organization
        cell.delegate = self
        
        return cell
    }
    
    func selectedOrganization(organization: Organization) {
        delegate.selectedOrganization(organization: organization)
        animateOrganizationList()
    }
}
