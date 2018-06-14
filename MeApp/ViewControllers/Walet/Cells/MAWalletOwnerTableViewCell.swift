//
//  MAWalletOwnerTableViewCell.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/14/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SwipeCellKit

class MAWalletOwnerTableViewCell: SwipeTableViewCell {
    @IBOutlet weak var paketName: UILabel!
    @IBOutlet weak var validTimeLabel: UILabel!
    @IBOutlet weak var bodyView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         bodyView.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
