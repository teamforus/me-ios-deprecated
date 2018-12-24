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
}

class OrganizationTableViewCell: UITableViewCell {
    @IBOutlet var organizationImageView: UIImageView!
    @IBOutlet var organizationNameLabel: UILabel!
    weak var delegate: OrganizationTableViewCellDelegate!
    var organization: Organization? {
        didSet{
            self.organizationNameLabel.text = organization?.name
            if organization?.logo != nil {
                self.organizationImageView.sd_setImage(with: URL(string: organization?.logo!.sizes.thumbnail ?? ""), placeholderImage: UIImage(named: "Resting"))
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
        delegate.selectedOrganization(organization: organization!)
    }
    
}
