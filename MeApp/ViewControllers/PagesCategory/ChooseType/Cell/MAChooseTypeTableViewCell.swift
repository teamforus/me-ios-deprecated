//
//  MAChooseTypeTableViewCell.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/25/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

protocol MAChooseTypeTableViewCellDelegate: class {
    func chooseType(cell: MAChooseTypeTableViewCell)
}

import UIKit
import UICheckbox_Swift

class MAChooseTypeTableViewCell: UITableViewCell {
    @IBOutlet weak var typeButton: ShadowButton!
    @IBOutlet weak var checkBox: UICheckbox!
    var isSelectedCell: Bool! = false
    @IBOutlet weak var titleRecordType: UILabel!
    @IBOutlet weak var viewTypeRecord: CustomCornerUIView!
    weak var delegate: MAChooseTypeTableViewCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gestureRecognize = UITapGestureRecognizer(target:self, action: #selector(chooseTypeRecord))
        self.contentView.isUserInteractionEnabled = true
        self.contentView.addGestureRecognizer(gestureRecognize)
    }
    
    @objc func chooseTypeRecord(){
        delegate.chooseType(cell: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
