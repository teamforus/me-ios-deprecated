//
//  PassSecondTableViewCell.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/21/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class WalletSecondTableViewCell: UITableViewCell {
    @IBOutlet weak var viewBody: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewBody.layer.cornerRadius = 9.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
