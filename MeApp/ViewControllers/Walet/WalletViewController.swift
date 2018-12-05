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

enum WalletCase {
    case token
    case assets
    case passes
}

class WalletViewController: MABaseViewController, AppLockerDelegate, NVActivityIndicatorViewable {
    func closePinCodeView(typeClose: typeClose) {
    }

    let reachability = Reachability()!
    @IBOutlet var tableView: UITableView!
    var walletCase: WalletCase! = WalletCase.token
    @IBOutlet var segmentView: UIView!
    var vouhers: NSMutableArray! = NSMutableArray()
    var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet var emptyTextLabe: UILabel!

    //    @IBOutlet weak var voiceButton: VoiceButtonView!
    @IBOutlet var segmentedControl: HBSegmentedControl!
    let largerRedTextSelectAttributes = [NSAttributedStringKey.font: UIFont(name: "GoogleSans-Medium", size: 14.0),
                                         NSAttributedStringKey.foregroundColor: UIColor.white]

    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.string(forKey: ALConstants.kPincode) != "" && UserDefaults.standard.string(forKey: ALConstants.kPincode) != nil {
            var appearance = ALAppearance()
            appearance.image = UIImage(named: "lock")!
            appearance.title = "Enter login code".localized()
            appearance.isSensorsEnabled = true
            appearance.cancelIsVissible = false
            appearance.delegate = self

            AppLocker.present(with: .validate, and: appearance, withController: self)
        }
        walletCase = WalletCase.passes

        //        segmentView.layer.cornerRadius = 8.0
        //        tableView.setContentOffset(CGPoint(x: 0, y: 44), animated: true)
        //        segmentedControl.items = ["Valuta", "Bezit", "Vouchers"]
        //        segmentedControl.selectedIndex = 0
        //        segmentedControl.font = UIFont(name: "GoogleSans-Medium", size: 14)
        //        segmentedControl.unselectedLabelColor = #colorLiteral(red: 0.631372549, green: 0.6509803922, blue: 0.6784313725, alpha: 1)
        //        segmentedControl.selectedLabelColor = #colorLiteral(red: 0.2078431373, green: 0.3921568627, blue: 0.968627451, alpha: 1)
        //        segmentedControl.addTarget(self, action: #selector(self.segmentSelected(sender:)), for: .valueChanged)
        //        segmentedControl.borderColor = .clear
        tableView.keyboardDismissMode = .onDrag
        Web3Provider.getBalance()
        Service.sendContract { _, _ in
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "currentUser == YES")
        do {
            let results = try context.fetch(fetchRequest) as? [User]
            if results?.count != 0 {
                UserShared.shared.currentUser = results![0]
                UserDefaults.standard.set(UserShared.shared.currentUser.pinCode, forKey: ALConstants.kPincode)
                UserDefaults.standard.synchronize()
            }
        } catch {}

        let size = CGSize(width: 60, height: 60)

        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 32)!, color: #colorLiteral(red: 0.1918309331, green: 0.3696506619, blue: 0.9919955134, alpha: 1), textColor: .black, fadeInAnimation: nil)
        getVoucherList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        IndentityRequest.requestIndentiy(completion: { (identityAddress, statuCode) in
//            Crashlytics.sharedInstance().setUserIdentifier(identityAddress.address)
//        }) { (error) in
//
//        }
        navigationController?.setNavigationBarHidden(false, animated: true)
        title = "Voucher"
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
            self.tableView.contentInset = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)

        } else {
            // Fallback on earlier versions
        }
        getVoucherList()
        //  ConfigRequest.getConfig(configType: "wallet", completion: { (statuCode, response) in

        // }) { (error) in }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.isHidden = false
            self.view.setNeedsDisplay()
            self.view.layoutSubviews()
        }
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

    //    @objc func segmentSelected(sender:HBSegmentedControl) {
    //        print("Segment at index \(sender.selectedIndex)  selected")
    //        if (sender.selectedIndex == 0 ){
    //            walletCase = WalletCase.token
    //            self.tableView.reloadData()
    //        }else if (sender.selectedIndex == 1){
    //            walletCase = WalletCase.assets
    //            self.tableView.reloadData()
    //        }else if (sender.selectedIndex == 2){
    //            walletCase = WalletCase.passes
    //            self.tableView.reloadData()
    //        }
    //
    //    }
    @IBAction func logout(_ sender: Any) {
        logOut()
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

// MARK: - VoiceButtonDelegate

extension WalletViewController: VoiceButtonDelegate {
    func updateSpeechText(_ text: String) {
    }

    func startedRecording() {
        print("")
    }

    func stoppedRecording() {
        print("")
    }

    func notifyError(_ error: String) {
        print(error)
    }
}

// MARK: UITableViewDelegate

extension WalletViewController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if walletCase == .passes {
            return vouhers.count
        }
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MAWaletVoucherTableViewCell
        cell.selectionStyle = .none
        let voucher = vouhers[indexPath.row] as! Voucher

        if voucher.product != nil {
            cell.usedVoucherLabel.isHidden = true
            cell.voucherTitleLabel.text = voucher.product?.name
            cell.priceLabel.text = "€\(voucher.product?.price ?? "0.0")"
            if voucher.product?.photo != nil {
                cell.voucherImage.sd_setImage(with: URL(string: voucher.product?.photo.sizes.thumbnail ?? ""), placeholderImage: UIImage(named: "Resting"))
            }
        } else {
            cell.voucherTitleLabel.text = voucher.found.name
            cell.usedVoucherLabel.isHidden = true
            cell.priceLabel.text = "€\(voucher.amount ?? "0.0")"
            if voucher.found.logo != nil {
                cell.voucherImage.sd_setImage(with: URL(string: voucher.found.logo.sizes.thumbnail ?? ""), placeholderImage: UIImage(named: "Resting"))
            }
        }
        cell.organizationNameLabel.text = voucher.found.organization.name

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let voucher = vouhers[indexPath.row] as! Voucher
        if voucher.product != nil {
            performSegue(withIdentifier: "goToVoucherProduct", sender: nil)
        } else {
            performSegue(withIdentifier: "goToKindPaket", sender: nil)
        }
        //        if segmentedControl.selectedIndex == 1 {
        //            //            let popOverVC = TransactionViewController(nibName: "TransactionViewController", bundle: nil)
        //            //            self.addChildViewController(popOverVC)
        //            //            popOverVC.view.frame = self.view.frame
        //            //            popOverVC.isVisisbeTabBar = true
        //            //            self.view.addSubview(popOverVC.view)
        //            //            popOverVC.didMove(toParentViewController: self)
        //            let alert: UIAlertController
        //            alert = UIAlertController(title: "", message: "Comming Soon!", preferredStyle: .alert)
        //            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
        //            }))
        //            self.present(alert, animated: true, completion: nil)
        //        }else if segmentedControl.selectedIndex == 2{
        //            self.performSegue(withIdentifier: "goToKindPaket", sender: self)
        //        }
        //        self.performSegue(withIdentifier: "goToKindPaket", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch walletCase {
        case .token?:
            return 130
        case .passes?:
            return 130
        default:
            break
        }
        return 142
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

        switch walletCase {
        case .token?: break
        case .assets?:
            if orientation == .right {
                return [deleteAction, transctionAction]
            }

        case .passes?:
            if orientation == .left {
                return [transctionAction]
            } else {
                return [deleteAction]
            }

        default: break
        }
        return nil
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
