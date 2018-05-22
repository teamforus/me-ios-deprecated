//
//  MARecordsTableViewCell.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/22/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import ExpandableCell

class MARecordsTableViewCell: ExpandableCell {
    @IBOutlet weak var titleCategory: UILabel!
    @IBOutlet weak var subcategoryTitle: UILabel!
    @IBOutlet weak var categoryIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

class ExpandedCell: UITableViewCell {
    static let ID = "ExpandedCell"
    
    @IBOutlet weak var infoCategory: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var validateChekBox: UIImageView!
}
