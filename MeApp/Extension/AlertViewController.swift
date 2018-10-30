//
//  AlertViewController.swift
//  AlertViewController
//
//  Created by Michael Inger on 26/07/2017.
//  Copyright © 2017 stringCode ltd. All rights reserved.
//

import UIKit
import SwiftMessages

class AlertController: UIAlertController {
    private(set) var originalTitle: String?
    private var spaceAdjustedTitle: String = ""
    private weak var imageView: UIImageView? = nil
    private var previousImgViewSize: CGSize = .zero
    
    override var title: String? {
        didSet {
            if title != spaceAdjustedTitle {
                originalTitle = title
            }
        }
    }
    
    func setTitleImage(_ image: UIImage?) {
        guard let imageView = self.imageView else {
            let imageView = UIImageView(image: image)
            self.view.addSubview(imageView)
            self.imageView = imageView
            return
        }
        imageView.image = image
    }
    
    // MARK: -  Layout code
    
    override func viewDidLayoutSubviews() {
        guard let imageView = imageView else {
            super.viewDidLayoutSubviews()
            return
        }
        if previousImgViewSize != imageView.bounds.size {
            previousImgViewSize = imageView.bounds.size
            adjustTitle(for: imageView)
        }
        let linesCount = newLinesCount(for: imageView)
        let padding = Constants.padding(for: preferredStyle)
        imageView.center.x = view.bounds.width / 2.0
        imageView.center.y = padding + linesCount * lineHeight / 2.0
        super.viewDidLayoutSubviews()
    }
    
    private func adjustTitle(for imageView: UIImageView) {
        let linesCount = Int(newLinesCount(for: imageView))
        let lines = (0..<linesCount).map({ _ in "\n" }).reduce("", +)
        spaceAdjustedTitle = lines + (originalTitle ?? "")
        title = spaceAdjustedTitle
    }
    
    static func showError(){
        let error = MessageView.viewFromNib(layout: .tabView)
        error.configureTheme(.error)
        error.configureContent(title: "Warning", body: "Something goes wrong please try again!" , iconImage: nil, iconText: "", buttonImage: nil, buttonTitle: "YES") { _ in
            SwiftMessages.hide()
        }
        error.button?.setTitle("OK", for: .normal)
        
        SwiftMessages.show( view: error)
    }
    
    static func showWarning(withText: String, vc: UIViewController){
        let alert: UIAlertController
        alert = UIAlertController(title: "Warning", message: withText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
        }))
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func showSuccess(withText: String){
        let error = MessageView.viewFromNib(layout: .tabView)
        error.configureTheme(.success)
        error.configureContent(title: "Success!", body: "" , iconImage: nil, iconText: "", buttonImage: nil, buttonTitle: "YES") { _ in
            SwiftMessages.hide()
        }
        error.button?.setTitle("OK", for: .normal)
        
        SwiftMessages.show( view: error)
    }
    
    static func showInternetUnable(){
        let error = MessageView.viewFromNib(layout: .tabView)
        error.configureTheme(.warning)
        error.configureContent(title: "Warning!", body: "No Internet Conecction" , iconImage: nil, iconText: "", buttonImage: nil, buttonTitle: "YES") { _ in
            SwiftMessages.hide()
        }
        error.button?.setTitle("OK", for: .normal)
        
        SwiftMessages.show( view: error)
    }
    
    private func newLinesCount(for imageView: UIImageView) -> CGFloat {
        return ceil(imageView.bounds.height / lineHeight)
    }
    
    private lazy var lineHeight: CGFloat = {
        let style: UIFontTextStyle = self.preferredStyle == .alert ? .headline : .callout
        return UIFont.preferredFont(forTextStyle: style).pointSize
    }()
    
    struct Constants {
        static var paddingAlert: CGFloat = 22
        static var paddingSheet: CGFloat = 11
        static func padding(for style: UIAlertControllerStyle) -> CGFloat {
            return style == .alert ? Constants.paddingAlert : Constants.paddingSheet
        }
    }
}
