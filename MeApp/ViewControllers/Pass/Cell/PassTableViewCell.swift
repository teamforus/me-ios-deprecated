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
    var transaction: Transactions?{
        didSet{
            self.statusTransfer.text = transaction?.product != nil ? "Product voucher".localized() : "Transaction".localized()
            self.companyTitle.text = transaction?.product != nil ? transaction?.product?.name : transaction?.organization.name
            if transaction?.product?.photo != nil || transaction?.organization != nil {
                self.imageTransfer.sd_setImage(with: URL(string: (transaction?.product != nil ? transaction?.product?.photo?.sizes?.thumbnail : transaction?.organization.logo?.sizes?.thumbnail)!), placeholderImage: UIImage(named: "Resting"))
            }
            self.priceLabel.text = "- \(transaction?.amount! ?? "0.0")"
            self.dateLabel.text = transaction?.created_at.dateFormaterNormalDate()
        }
    }
    
    
    @IBOutlet weak var imageEarth: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        bodyView.layer.cornerRadius = 8.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
