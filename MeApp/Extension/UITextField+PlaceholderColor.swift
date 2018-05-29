//
//  UITextField+PlaceholderColor.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/24/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

extension UITextField{
    func placeholderColor(text: String, withColor: UIColor)  {
        self.attributedPlaceholder = NSAttributedString(string: text ,attributes: [NSAttributedStringKey.foregroundColor: withColor])
        
    }
}
