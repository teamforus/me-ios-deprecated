//
//  MAWaletVoucherTableViewCell.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 8/3/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SwipeCellKit

class MAWaletVoucherTableViewCell: SwipeTableViewCell {
    @IBOutlet weak var voucherTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var voucherImage: UIImageView!
    @IBOutlet weak var organizationNameLabel: UILabel!
    @IBOutlet weak var usedVoucherLabel: UILabel!
    var voucher: Voucher? {
        didSet{
            self.voucherTitleLabel.text = voucher?.product != nil ? voucher?.product?.name : voucher?.found.name
            self.organizationNameLabel.text = voucher?.found.organization.name
            if voucher?.product != nil{
                self.priceLabel.isHidden = true
            }else{
                self.priceLabel.isHidden = false
                self.priceLabel.text = "€ " + (voucher?.amount)!
            }
            
            if voucher?.transactions != nil{
                usedVoucherLabel.isHidden = false
                usedVoucherLabel.text = "Used".localized()
            } else {
                self.usedVoucherLabel.isHidden = true
            }
            if Date().dateFormaterFromServer(dateString: voucher?.expireAt?.date ?? "") <= Date(){
                usedVoucherLabel.textColor = .lightGray
                usedVoucherLabel.text = "Expired".localized()
            }
            
            if voucher?.product?.photo != nil || voucher?.found.logo != nil {
                self.voucherImage.sd_setImage(with: URL(string: (voucher?.product != nil ? voucher?.product?.photo?.sizes?.thumbnail : voucher?.found.logo.sizes?.thumbnail) ?? ""), placeholderImage: UIImage(named: "Resting"))
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
