//
//  MAChooseCategoryViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/20/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MAChooseCategoryViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var arryaTitle : [String] = ["Persoonlijk","Medisch","Persoonlijk","Medisch","Persoonlijk","Medisch"]
    var previusCell: MAChooseCategoryCollectionViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRecordCategory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getRecordCategory(){
        RecordCategoryRequest.getRecordCategory(completion: { (response) in
//            self.recordTypeList.addObjects(from: response as! [Any])
//            self.tableView.reloadData()
        }) { (error) in
            
        }
    }
    

}

extension MAChooseCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MAChooseCategoryCollectionViewCell
        cell.titleCategory.text = arryaTitle[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MAChooseCategoryCollectionViewCell
        cell.viewBody.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8980392157, blue: 0.9725490196, alpha: 1)
        if previusCell != nil {
        previusCell.viewBody.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        }
        previusCell = cell
        UserDefaults.standard.set(arryaTitle[indexPath.row], forKey: "category")
        NotificationCenter.default.post(name: Notification.Name("SETSELECTEDCATEGORY"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("EnableNextButton"), object: nil)
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.size.width / 2 - 25, height: 110)
    }
}

