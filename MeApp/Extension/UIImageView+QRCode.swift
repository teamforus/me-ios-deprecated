//
//  UIImageView+QRCode.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/24/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

extension UIImageView{
    func generateQRCode(from string: String)  {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                self.image =  UIImage(ciImage: output)
            }
        }
        
       
    }
}
