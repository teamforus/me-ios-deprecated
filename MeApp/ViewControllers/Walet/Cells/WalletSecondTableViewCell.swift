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
        self.viewBody.layer.shadowColor = UIColor.black.cgColor;
        self.viewBody.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.viewBody.layer.shadowOpacity = 0.07
        self.viewBody.layer.shadowRadius = 10.0
        self.viewBody.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
