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
    @IBOutlet weak var headNameLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var marcLabel: UILabel!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var typeIconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewBody.layer.cornerRadius = 9.0
        let path = UIBezierPath(roundedRect:CGRect(x: 0, y: 0, width: headView.frame.size.width + 40, height: headView.frame.size.height),
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: 9, height:  9))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        self.headView.layer.mask = maskLayer
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
