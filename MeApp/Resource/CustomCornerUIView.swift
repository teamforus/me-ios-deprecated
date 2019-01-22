//
//  CustomCornerUIView.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/20/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit


@IBDesignable
class CustomCornerUIView: UIView {

    @IBInspectable var selectedShadowColor : UIColor = UIColor.black {
        didSet {
            setSelectShadowColor()
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet {
            setCornerRadius()
        }
    }
    
    @IBInspectable var shadowOffset : CGSize = CGSize(width: 0, height: 0) {
        didSet {
            setShadowOffset()
        }
    }
    
    @IBInspectable var shadowOpacity : Float = 0 {
        didSet {
            setShadowOpacity()
        }
    }
    
    @IBInspectable var shadowRadius : CGFloat = 0 {
        didSet {
            setShadowRadius()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = false
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        self.layer.masksToBounds = false
    }
    
    func setCornerRadius(){
        self.layer.cornerRadius = cornerRadius
    }
    
    func setSelectShadowColor(){
        self.layer.shadowColor = selectedShadowColor.cgColor
    }
    
    func setShadowOffset(){
        self.layer.shadowOffset = shadowOffset
    }
    
    func setShadowOpacity(){
        self.layer.shadowOpacity = shadowOpacity
    }
    
    func setShadowRadius(){
        self.layer.shadowRadius = shadowRadius
    }


}
