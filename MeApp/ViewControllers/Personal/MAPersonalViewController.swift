//
//  MAPersonalViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/20/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Reachability
import BWWalkthrough

class MAPersonalViewController: MABaseViewController, BWWalkthroughViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    var recordList: NSMutableArray! = NSMutableArray()
    var recordTypeList: NSMutableArray! = NSMutableArray()
    let reachablity = Reachability()!
    var walkthrough: BWWalkthroughViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       setupView()
    }
    
    fileprivate func setupView(){
        self.tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(closePage), name: Notification.Name("CLOSESLIDEPAGE"), object: nil)
        if reachablity.connection != .none{
            ConfigRequest.getConfig(configType: "records", completion: { (statuCode, response) in
                
            }) { (error) in }
            getRecordType()
            getRecordList()
        }else {
            AlertController.showInternetUnable(vc: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func closePage(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func getRecordType(){
        RecordTypeRequest.getRecordType(completion: { (response, statusCode) in
            if statusCode == 401{
                AlertController.showError(vc:self)
                return
            }
            self.recordTypeList.addObjects(from: response as! [Any])
        }) { (error) in
            AlertController.showError(vc:self)
        }
    }
    
    func getRecordList(){
        RecordsRequest.getRecordsList(completion: { (response, statusCode) in
            if statusCode == 401{
                AlertController.showError(vc:self)
                return
            }
            self.recordList.removeAllObjects()
            self.recordList.addObjects(from: response as! [Any])
            self.tableView.reloadData()
        }) { (error) in
            AlertController.showError(vc:self)
        }
    }
    
    // MARK: - Walkthrough delegate -
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        if pageNumber == 3{
            NotificationCenter.default.post(name: Notification.Name("HidePageNumber"), object: nil)
        }
    }
    
    func walkthroughCloseButtonPressed() {
        walkthrough.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail"{
            let detailPersonalVC = segue.destination as! MAContentPersonalDetailViewController
            detailPersonalVC.record = self.recordList[(tableView.indexPathForSelectedRow?.row)!] as? Record
            (detailPersonalVC.contentViewController as! MAPersonalDetailViewController).record = self.recordList[(tableView.indexPathForSelectedRow?.row)!] as? Record
              (detailPersonalVC.contentViewController as! MAPersonalDetailViewController).recordTypeList = recordTypeList
            (detailPersonalVC.bottomViewController as! MABottomPersonalQRViewController).record = self.recordList[(tableView.indexPathForSelectedRow?.row)!] as? Record
        }
    }
    
    @IBAction func createRecord(_ sender: Any) {
        let stb = UIStoryboard(name: "NewProfile", bundle: nil)
        walkthrough = stb.instantiateViewController(withIdentifier: "walk") as? BWWalkthroughViewController
        let pageOne = stb.instantiateViewController(withIdentifier: "types")
        let pageTwo = stb.instantiateViewController(withIdentifier: "text")
        
        walkthrough.delegate = self
        walkthrough.scrollview.isScrollEnabled = false
        walkthrough.add(viewController:pageOne)
        walkthrough.add(viewController:pageTwo)
        
        self.present(walkthrough, animated: true, completion: nil)
    }
    
}

extension MAPersonalViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MAPersonalTableViewCell
        let record = recordList[indexPath.row] as! Record
        if record.validations.count != 0 {
            cell.validateText.isHidden = false
            cell.validationNumber.text = "\(record.validations.count)"
        }else {
            cell.validateText.isHidden = true
            cell.validationNumber.isHidden = true
        }
       
        for recordType in recordTypeList{
            if (recordType as! RecordType).key == record.key{
                cell.cellTypeLabel.text = (recordType as! RecordType).name
            }
        }
        cell.nameLabel.text = record.value
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
