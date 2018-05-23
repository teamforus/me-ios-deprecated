//
//  MANavicationController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/23/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MANavicationController: NSObject {
    
    
    fileprivate weak var navigationController: UINavigationController?
    
    // MARK: - Init
    
    init(controller: UINavigationController) {
        self.navigationController = controller
        
        super.init()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}

extension MANavicationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (navigationController?.viewControllers.count ?? 0) > 1
    }
    
    // This is necessary because without it, subviews of your top controller can cancel out your gesture recognizer on the edge.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}


class HiddenNavBarNavigationController: UINavigationController {
    
    // MARK: - Properties
    
    private var popRecognizer: MANavicationController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopRecognizer()
    }
    
    // MARK: - Setup
    
    private func setupPopRecognizer() {
        popRecognizer = MANavicationController(controller: self)
    }
}
