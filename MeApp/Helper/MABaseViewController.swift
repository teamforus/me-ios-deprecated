//
//  MABaseViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/24/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Presentr

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
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func back(_ sender : Any)  {
        self.navigationController?.popViewController(animated: true)
    }
    


}
