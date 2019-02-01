//
//  WalletViewController.swift
//  TestProject
//
//  Created by Tcacenco Daniel on 5/8/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import CoreData
import Crashlytics
import NVActivityIndicatorView
import Reachability
import ScrollableSegmentedControl
import SDWebImage
import Speech
import SwipeCellKit
import UIKit
import Presentr

enum WalletCase {
    case token
    case assets
    case passes
}

class WalletViewController: MABaseViewController, AppLockerDelegate, NVActivityIndicatorViewable {
   
    
    let reachability = Reachability()!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentView: UIView!
    var vouhers: NSMutableArray! = NSMutableArray()
    var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet var emptyTextLabe: UILabel!
    var firstTimeEnter: Bool!
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    fileprivate func setupView(){
        title = "Voucher"
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
            self.tableView.contentInset = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
            
        } else {
            // Fallback on earlier versions
        }
        
        if !UserDefaults.standard.bool(forKey: "isStartFromScanner"){
            if UserDefaults.standard.string(forKey: ALConstants.kPincode) != "" && UserDefaults.standard.string(forKey: ALConstants.kPincode) != nil {
                var appearance = ALAppearance()
                appearance.image = UIImage(named: "lock")!
                appearance.title = "Enter login code".localized()
                appearance.isSensorsEnabled = true
                appearance.cancelIsVissible = false
                appearance.delegate = self
                
                AppLocker.present(with: .validate, and: appearance, withController: self)
            }
        }
        //        Web3Provider.getBalance()
        //        Service.sendContract { _, _ in
        //        }
        getCurrentUser()
        
        if firstTimeEnter != nil{
            let popupTransction =  MACrashConfirmViewController(nibName: "MACrashConfirmViewController", bundle: nil)
            self.presenter.presentationType = .popup
            self.presenter.transitionType = nil
            self.presenter.dismissTransitionType = nil
            self.presenter.keyboardTranslationType = .compress
            self.customPresentViewController(self.presenter, viewController: popupTransction, animated: true, completion: nil)
        }
        
        
        let size = CGSize(width: 60, height: 60)
        
        startAnimating(size, message: "Loading...".localized(), type: NVActivityIndicatorType(rawValue: 32)!, color: #colorLiteral(red: 0.1918309331, green: 0.3696506619, blue: 0.9919955134, alpha: 1), textColor: .black, fadeInAnimation: nil)
        getVoucherList()
        
        if UserDefaults.standard.bool(forKey: "ISENABLESENDADDRESS"){
            IndentityRequest.requestIndentiy(completion: { (identityAddress, statuCode) in
                Crashlytics.sharedInstance().setUserIdentifier(identityAddress.address)
            }) { (error) in }
        }
        
        sendPushNotificationToke()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        setStatusBarStyle(.default)
        getVoucherList()
    }
    
    fileprivate func sendPushNotificationToke(){
        IndentityRequest.sendTokenNotification(completion: { (user, statusCode) in
            
        }) { (error) in }
    }
    
    func getVoucherList() {
        VoucherRequest.getVoucherList(completion: { response, _ in
            self.vouhers.removeAllObjects()
            for voucher in response {
                if (voucher as! Voucher).product != nil {
                    if (voucher as! Voucher).transactions.count == 0 {
                        self.vouhers.add(voucher)
                    }
                } else {
                    self.vouhers.add(voucher)
                }
            }
            if self.vouhers.count == 0 {
                self.emptyTextLabe.isHidden = false
            } else {
                self.emptyTextLabe.isHidden = true
            }
            self.tableView.reloadData()
            self.stopAnimating(nil)
        }) { _ in
            self.stopAnimating(nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToKindPaket" {
            let passVC = segue.destination as! MAGeneralPassViewController
            (passVC.contentViewController as! PassViewController).voucher = vouhers[(self.tableView.indexPathForSelectedRow?.row)!] as? Voucher
            (passVC.bottomViewController as! MABottomVoucherViewController).voucher = vouhers[(self.tableView.indexPathForSelectedRow?.row)!] as? Voucher
        } else if segue.identifier == "goToVoucherProduct" {
            let passVC = segue.destination as! MAContenProductVoucherViewController
            (passVC.contentViewController as! MAProductVoucherViewController).voucher = vouhers[(self.tableView.indexPathForSelectedRow?.row)!] as? Voucher
            (passVC.bottomViewController as! MABottomProductViewController).voucher = vouhers[(self.tableView.indexPathForSelectedRow?.row)!] as? Voucher
        }
    }
}

// MARK: UITableViewDelegate

extension WalletViewController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vouhers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MAWaletVoucherTableViewCell
        cell.selectionStyle = .none
        cell.voucher = vouhers[indexPath.row] as? Voucher
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let voucher = vouhers[indexPath.row] as! Voucher
        if voucher.product != nil {
            performSegue(withIdentifier: "goToVoucherProduct", sender: nil)
        } else {
            performSegue(withIdentifier: "goToKindPaket", sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // MARK: SwipeTableViewCellDelegate
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let transctionAction = SwipeAction(style: .default, title: "Transaction") { _, _ in
        }
        transctionAction.backgroundColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1.0)
        transctionAction.textColor = UIColor.lightGray
        transctionAction.image = UIImage(named: "transactionIcon")
        transctionAction.font = UIFont(name: "SFUIText-Bold", size: 10.0)
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { _, _ in
        }
        deleteAction.backgroundColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1.0)
        deleteAction.textColor = UIColor.lightGray
        deleteAction.image = UIImage(named: "removeIcon")
        deleteAction.font = UIFont(name: "SFUIText-Bold", size: 10.0)
        
        if orientation == .left {
            return [transctionAction]
        } else {
            return [deleteAction]
        }
        
    }
    
    func closePinCodeView(typeClose: typeClose) {
        if typeClose == .logout{
            logOutProfile()
        }
    }
    
    func logOutProfile(){
        UserDefaults.standard.set("", forKey: ALConstants.kPincode)
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController:HiddenNavBarNavigationController = storyboard.instantiateInitialViewController() as! HiddenNavBarNavigationController
        let firstPageVC:UIViewController = storyboard.instantiateViewController(withIdentifier: "firstPage") as UIViewController
        navigationController.viewControllers = [firstPageVC]
        self.present(navigationController, animated: true, completion: nil)
    }
}

extension WalletViewController {
    func createAnimationLoader() {
        view.backgroundColor = UIColor(red: CGFloat(237 / 255.0), green: CGFloat(85 / 255.0), blue: CGFloat(101 / 255.0), alpha: 1)
        
        let cols = 4
        let rows = 8
        let cellWidth = Int(view.frame.width / CGFloat(cols))
        let cellHeight = Int(view.frame.height / CGFloat(rows))
        (NVActivityIndicatorType.ballPulse.rawValue ... NVActivityIndicatorType.circleStrokeSpin.rawValue).forEach {
            let x = ($0 - 1) % cols * cellWidth
            let y = ($0 - 1) / cols * cellHeight
            let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
            let activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                                type: NVActivityIndicatorType(rawValue: $0)!)
            let animationTypeLabel = UILabel(frame: frame)
            
            animationTypeLabel.text = String($0)
            animationTypeLabel.sizeToFit()
            animationTypeLabel.textColor = UIColor.white
            animationTypeLabel.frame.origin.x += 5
            animationTypeLabel.frame.origin.y += CGFloat(cellHeight) - animationTypeLabel.frame.size.height
            
            activityIndicatorView.padding = 20
            if $0 == NVActivityIndicatorType.orbit.rawValue {
                activityIndicatorView.padding = 0
            }
            self.view.addSubview(activityIndicatorView)
            self.view.addSubview(animationTypeLabel)
            activityIndicatorView.startAnimating()
        }
    }
    
}
