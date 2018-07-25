//
//  MAChooseTypeTableViewCell.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/25/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import UICheckbox_Swift

class MAChooseTypeTableViewCell: UITableViewCell {
    @IBOutlet weak var typeButton: ShadowButton!
    @IBOutlet weak var checkBox: UICheckbox!
    @IBOutlet weak var titleRecordType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
