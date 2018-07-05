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
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusTransfer: UILabel!
    @IBOutlet weak var imageRectView: UIView!
    @IBOutlet weak var imageTransfer: UIImageView!
    
    
    @IBOutlet weak var imageEarth: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        bodyView.layer.cornerRadius = 8.0
        imageRectView.layer.cornerRadius = 12.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
