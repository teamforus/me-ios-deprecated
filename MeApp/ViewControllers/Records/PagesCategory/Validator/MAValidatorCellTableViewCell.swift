//
//  MAValidatorCellTableViewCell.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/23/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MAValidatorCellTableViewCell: UITableViewCell {
    @IBOutlet weak var nameValidator: UILabel!
    @IBOutlet weak var descriptionValidator: UILabel!
    @IBOutlet weak var iconValidator: UIImageView!
    var validator: Validations!{
        didSet{
             self.nameValidator.text = validator.identityAddress
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
