//
//  MABaseViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/24/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Presentr
import CoreData
import Reachability

class MABaseViewController: UIViewController {
    let dynamicSizePresenter: Presentr = {
        let presentationType = PresentationType.dynamic(center: .center)
        
        let presenter = Presentr(presentationType: presentationType)
        
        return presenter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
   public func logOut(){
//        self.parent?.dismiss(animated: true, completion: nil)
     UserDefaults.standard.set("", forKey: ALConstants.kPincode)
    let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let navigationController:HiddenNavBarNavigationController = storyboard.instantiateInitialViewController() as! HiddenNavBarNavigationController
     let firstPageVC:UIViewController = storyboard.instantiateViewController(withIdentifier: "firstPage") as UIViewController
     navigationController.viewControllers = [firstPageVC]
    self.present(navigationController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func back(_ sender : Any)  {
        self.navigationController?.popViewController(animated: true)
    }
    


}
