//
//  WaletTableViewCell.swift
//  TestProject
//
//  Created by Tcacenco Daniel on 5/9/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SwipeCellKit

class WaletTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var titleWalteCategory: UILabel!
    @IBOutlet weak var validatioDays: UILabel!
    @IBOutlet weak var priceUILabel: UILabel!
    @IBOutlet weak var bodyUIView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        bodyUIView.layer.cornerRadius = 5.0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
