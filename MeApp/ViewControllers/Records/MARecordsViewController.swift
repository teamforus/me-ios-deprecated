//
//  MARecordsViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/22/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import BWWalkthrough

class MARecordsViewController: MABaseViewController, BWWalkthroughViewControllerDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    var recordList: NSMutableArray! = NSMutableArray()
    
    
    var titles : NSArray = ["Personal".localized() ,"Medical".localized() ,"Business".localized() ,"Relationships".localized() ,"Certificates".localized() ,"Others".localized()]
    var images : NSArray = ["iconPersonal","iconMedical","iconBuissness","iconRelations","iconCertificate","iconOther"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(closePage), name: Notification.Name("CLOSESLIDEPAGE"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        //        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //        self.title = "Eigenschappen"
        //        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.getRecordList()
    }
    
    func getRecordList(){
        RecordsRequest.getRecordsList(completion: { (response, statusCode) in
            if statusCode == 401{
                self.logOut()
                return
            }
            self.recordList.removeAllObjects()
            self.recordList.addObjects(from: response as! [Any])
        }) { (error) in
            AlertController.showError(vc:self)
        }
    }
    
    @objc func closePage(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Walkthrough delegate 
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        if pageNumber == 3{
            NotificationCenter.default.post(name: Notification.Name("HidePageNumber"), object: nil)
        }
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createRecord(_ sender: Any) {
        let stb = UIStoryboard(name: "NewProfile", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController
        let page_zero = stb.instantiateViewController(withIdentifier: "categories")
        let pageOne = stb.instantiateViewController(withIdentifier: "types")
        let pageTwo = stb.instantiateViewController(withIdentifier: "text")
        
        walkthrough.delegate = self
        walkthrough.scrollview.isScrollEnabled = false
        walkthrough.add(viewController:page_zero)
        walkthrough.add(viewController:pageOne)
        walkthrough.add(viewController:pageTwo)
        
        self.present(walkthrough, animated: true, completion: nil)
    }
}

extension MARecordsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        return cell
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
