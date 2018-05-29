//
//  TabBarController.swift
//  TestProject
//
//  Created by Tcacenco Daniel on 5/9/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addCenterButton(withImage: UIImage.init(named: "qrButton")!, highlightImage: UIImage.init(named: "qrButton")!)
        self.tabBar.barTintColor = UIColor.white
        let largerRedTextSelectAttributes = [NSAttributedStringKey.font: UIFont(name: "SFProText-Semibold", size: 10.0),
                                             NSAttributedStringKey.foregroundColor: UIColor.white]
        self.tabBarItem.setTitleTextAttributes(largerRedTextSelectAttributes as Any as? [NSAttributedStringKey : Any], for: .normal)
    }
    
    @objc func handleTouchTabbarCenter(sender : UIButton)
    {
        if let count = self.tabBar.items?.count
        {
            let i = floor(Double(count / 2))
            self.selectedViewController = self.viewControllers?[Int(i)]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    -(void)viewDidLayoutSubviews
//    {
//    [super viewDidLayoutSubviews];
//    [self.tabBar invalidateIntrinsicContentSize];
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tabBar.invalidateIntrinsicContentSize()
    }
    
    func addCenterButton(withImage buttonImage : UIImage, highlightImage: UIImage) {
        
        let paddingBottom : CGFloat!
        if UIScreen.main.nativeBounds.height == 2436 {
            paddingBottom  = 15.0
        }else{
            paddingBottom = 20.0
        }
        
        let button = UIButton(type: .custom)
        button.autoresizingMask = [.flexibleRightMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin]
        button.frame = CGRect(x: 0.0, y: 0.0, width: buttonImage.size.width / 2.0, height: buttonImage.size.height / 2.0)
        button.setBackgroundImage(buttonImage, for: .normal)
        button.setBackgroundImage(highlightImage, for: .highlighted)
        
        let rectBoundTabbar = self.tabBar.bounds
        let xx = rectBoundTabbar.midX
        let yy : CGFloat!
        if UIScreen.main.nativeBounds.height == 2436 {
            yy = rectBoundTabbar.midY + paddingBottom
        }else{
            yy = rectBoundTabbar.midY - paddingBottom
        }
        
        button.center = CGPoint(x: xx, y: yy)
        
        self.tabBar.addSubview(button)
        self.tabBar.bringSubview(toFront: button)
        
        button.addTarget(self, action: #selector(handleTouchTabbarCenter(sender:)), for: .touchUpInside)
        
        if let count = self.tabBar.items?.count
        {
            let i = floor(Double(count / 2))
            let item = self.tabBar.items![Int(i)]
            item.title = ""
        }
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
