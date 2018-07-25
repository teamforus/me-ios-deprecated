//
//  MAChooseTypeViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/20/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import UICheckbox_Swift
import BWWalkthrough

class MAChooseTypeViewController: UIViewController, BWWalkthroughPage {
    
    @IBOutlet weak var selectedCategory: ShadowButton!
    @IBOutlet weak var tableView: UITableView!
    var recordTypeList: NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setSelectedCategory), name: Notification.Name("SETSELECTEDCATEGORY"), object: nil)
        getRecordType()
    }
    
    func getRecordType(){
        RecordTypeRequest.getRecordType(completion: { (response) in
            self.recordTypeList.addObjects(from: response as! [Any])
            self.tableView.reloadData()
        }) { (error) in
            
        }
    }
    
    @objc func setSelectedCategory(){
        selectedCategory.setTitle(UserDefaults.standard.string(forKey: "category"), for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func walkthroughDidScroll(to: CGFloat, offset: CGFloat) {
       
    }
    
    @IBAction func selectType(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("EnableNextButton"), object: nil)
        
        NotificationCenter.default.post(name: Notification.Name("SETSELECTEDCATEGORYTYPE"), object: nil)
    }
}

extension MAChooseTypeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordTypeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MAChooseTypeTableViewCell
        let recordType = recordTypeList[indexPath.row] as! RecordType
        cell.titleRecordType.text = recordType.name
        
        return cell
    }
}
