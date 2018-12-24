//
//  MAAboutMeViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 8/31/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit
import SafariServices

class MAAboutMeViewController: MABasePopUpViewController, SFSafariViewControllerDelegate {
    var titleDetail: String!
    var descriptionDetail: String!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   @objc func tapLabel(gesture: UITapGestureRecognizer) {
        let text = (descriptionLabel.text)!
        let termsRange = (text as NSString).range(of: "https://zuidhorn.forus.io")
        
        if gesture.didTapAttributedTextInLabel(label: descriptionLabel, inRange: termsRange) {
            let safariVC = SFSafariViewController(url: URL(string: "https://zuidhorn.forus.io")!)
            self.present(safariVC, animated: true, completion: nil)
            safariVC.delegate = self
        } else { }
    }

}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
