//
//  OrganizationTableViewCell.swift
//  Me
//
//  Created by Tcacenco Daniel on 12/19/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit



protocol OrganizationTableViewCellDelegate: class {
    func selectedOrganization(organization: Organization)
    func didSelectAllowedOrganization(organization: AllowedOrganizations)
}

class OrganizationTableViewCell: UITableViewCell {
    @IBOutlet var organizationImageView: UIImageView!
    @IBOutlet var organizationNameLabel: UILabel!
    weak var delegate: OrganizationTableViewCellDelegate!
    var allowedOrganization: AllowedOrganizations? {
        didSet{
            if allowedOrganization?.logo != nil {
                self.organizationImageView.sd_setImage(with: URL(string: allowedOrganization?.logo!.sizes?.thumbnail ?? ""), placeholderImage: UIImage(named: "Resting"))
            }
            self.organizationNameLabel.text = allowedOrganization?.name
        }
    }
    var organization: Organization? {
        didSet{
            self.organizationNameLabel.text = organization?.name
            if organization?.logo != nil {
                self.organizationImageView.sd_setImage(with: URL(string: organization?.logo!.sizes?.thumbnail ?? ""), placeholderImage: UIImage(named: "Resting"))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func selectOrganization(_ sender: Any) {
        if organization != nil {
            delegate.selectedOrganization(organization: organization!)
        }else if allowedOrganization != nil{
            delegate.didSelectAllowedOrganization(organization: allowedOrganization!)
        }
    }
    
}
