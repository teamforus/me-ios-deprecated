//
//  PopUpOrganizationsViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 12/19/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit

enum TypeClose: Int {
    case show = 0
    case close = 1
}
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
        NotificationCenter.default.addObserver(self, selector: #selector(dissmisAnimte(_:)), name: Notification.Name("RemoveAnimateView"), object: nil)
    }
    
    func getOrganizationList(){
        OrganizationRequest.reqeustOrganizations(completion: { (organizations, statusCode) in
            self.organizations.removeAllObjects()
            self.organizations = organizations
            self.tableView.reloadData()
        }) { (error) in }
    }
    
    @IBAction func dissmisAnimte(_ sender: Any) {
        
    }
    
    func animateOrganizationList(){
        if !dropDownIsVisible{
            UIView.animate(withDuration: 0.4) {
                self.arrowImageView.layer.transform = CATransform3DRotate(CATransform3DIdentity, CGFloat(180 * Double.pi / 180), 1, 0, 0)
                var frame = self.view.frame
                frame.size.height = self.screenSize.height
                self.view.frame = frame
                self.viewDidLayoutSubviews()
            }
            dropDownIsVisible = true
        }else{
            UIView.animate(withDuration: 0.4) {
                self.arrowImageView.layer.transform = CATransform3DRotate(CATransform3DIdentity, CGFloat(180 * Double.pi / 180), 0, 0, 0)
                var frame = self.view.frame
                frame.size.height = 102
                self.view.frame = frame
                self.viewWillLayoutSubviews()
            }
            dropDownIsVisible = false
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
        let organization = organizations[indexPath.row] as! Organization
        cell.organization = organization
        cell.organizationNameLabel.text = organization.name ?? ""
        cell.delegate = self
        if organization.logo != nil {
            cell.organizationImageView.sd_setImage(with: URL(string: organization.logo!.sizes.thumbnail ?? ""), placeholderImage: UIImage(named: "Resting"))
        }
        return cell
    }
    
    func selectedOrganization(organization: Organization) {
        delegate.selectedOrganization(organization: organization)
        animateOrganizationList()
    }
}
