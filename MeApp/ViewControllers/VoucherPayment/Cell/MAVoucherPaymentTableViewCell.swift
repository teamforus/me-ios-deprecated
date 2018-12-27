//
//  MAVoucherPaymentTableViewCell.swift
//  Me
//
//  Created by Tcacenco Daniel on 10/10/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit

class MAVoucherPaymentTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryNameLabel: UILabel!
    var organization: AllowedProductCategories? {
        didSet{
            categoryNameLabel.text = organization?.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
