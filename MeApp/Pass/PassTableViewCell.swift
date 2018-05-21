//
//  PassTableViewCell.swift
//  TestProject
//
//  Created by Tcacenco Daniel on 5/9/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class PassTableViewCell: UITableViewCell {
    @IBOutlet weak var companyTitle: UILabel!
    @IBOutlet weak var price1UILabel: UILabel!
    @IBOutlet weak var price2UILabel: UILabel!
    
    
    @IBOutlet weak var imageEarth: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
