//
//  MABotomQrProfileViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/22/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import ISHPullUp
import AssistantKit
import CoreData

class MABotomQrProfileViewController: UIViewController, ISHPullUpSizingDelegate, ISHPullUpStateDelegate{
    @IBOutlet private weak var handleView: ISHPullUpHandleView!
    @IBOutlet private weak var rootView: UIView!
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var buttonLock: UIButton?
    @IBOutlet weak var qrCodeImageView: UIImageView!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var timer : Timer! = Timer()
    var authorizeToken: AuthorizeToken!
    
    private var firstAppearanceCompleted = false
    weak var pullUpController: ISHPullUpViewController!
    private var halfWayPoint = CGFloat(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isHidden = true
        topView.layer.cornerRadius = 14.0
        rootView.layer.cornerRadius = 14.0
        rootView.layer.shadowColor = UIColor.black.cgColor;
        rootView.layer.shadowOffset = CGSize(width: 0, height: -2)
        rootView.layer.shadowOpacity = 0.2
        rootView.layer.shadowRadius = 23 / 2
        
        NotificationCenter.default.addObserver(self, selector: #selector(toglePullUpView), name: Notification.Name("togleStateWindow"), object: nil)
        var rect: CGRect = self.rootView.frame
             let screen = Device.screen
        switch screen {
        case .inches_4_0:
            rect.size.height = 440
            break
        case .inches_4_7:
            rect.size.height = 500
            break
        case .inches_5_5:
            rect.size.height = 567
            break
        case .inches_5_8:
            rect.size.height = 567
            break
        default:
            break
            
        }
        self.rootView.frame = rect
    }
    
   @objc func toglePullUpView(){
    if pullUpController.state == .expanded{
        self.view.isHidden = true
    }else{
        self.view.isHidden = false
    }
        pullUpController.toggleState(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstAppearanceCompleted = true;
        AuthorizeTokenRequest.createToken(completion: { (response) in
            if response.authToken != nil{
            self.authorizeToken = response
            self.qrCodeImageView.generateQRCode(from: "authToken:\(response.authToken!)")
            self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.checkAuthorizeToken), userInfo: nil, repeats: true)
            }else{
                AlertController.showError()
            }
        }) { (error) in
            AlertController.showError()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if timer != nil {
        self.timer.invalidate()
        }
    }
    
    @objc func checkAuthorizeToken(){
        Status.checkStatus(accessToken: self.authorizeToken.accessToken, completion: { (code) in
            if code == 200 {
                self.timer.invalidate()
                self.saveNewIdentity(accessToken: self.authorizeToken.accessToken)
                self.updateOldIndentity()
                self.getCurrentUser(accessToken: self.authorizeToken.accessToken)
                NotificationCenter.default.post(name: Notification.Name("TokenIsValidate"), object: nil)
            }
        }) { (error) in
            AlertController.showError()
        }
    }
    
    func saveNewIdentity(accessToken: String){
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format:"accessToken == %@", accessToken)
        
        do{
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count == 0 {
                let newUser = NSManagedObject(entity: entity!, insertInto: context)
                newUser.setValue(true, forKey: "currentUser")
                newUser.setValue(accessToken, forKey: "accessToken")
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            }
        } catch{
            
        }
    }
    
    func updateOldIndentity(){
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format:"currentUser == YES")
        
        do{
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count == 0 {
                results![0].setValue(false, forKey: "currentUser")
                
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            }
        } catch{
            
        }
    }
    
    func getCurrentUser(accessToken: String!){
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format:"accessToken == %@", accessToken)
        
        do{
            let results = try context.fetch(fetchRequest) as? [User]
            UserShared.shared.currentUser = results![0]
            
        } catch{
            
        }
    }
    
    @objc private dynamic func handleTapGesture(gesture: UITapGestureRecognizer) {
        if pullUpController.isLocked {
            return
        }
        
        pullUpController.toggleState(animated: true)
    }
    
    @IBAction private func buttonTappedLearnMore(_ sender: AnyObject) {
    }
    
    @IBAction private func buttonTappedLock(_ sender: AnyObject) {
    }
    
    @IBAction func close(_ sender: Any) {
        if pullUpController.state == .expanded{
             pullUpController.toggleState(animated: true)
            self.view.isHidden = true
        }
    }
    
    
    // MARK: ISHPullUpSizingDelegate
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, maximumHeightForBottomViewController bottomVC: UIViewController, maximumAvailableHeight: CGFloat) -> CGFloat {
        let totalHeight = rootView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        
        halfWayPoint = totalHeight / 2.0
        return totalHeight
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, minimumHeightForBottomViewController bottomVC: UIViewController) -> CGFloat {
        return topView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height;
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, targetHeightForBottomViewController bottomVC: UIViewController, fromCurrentHeight height: CGFloat) -> CGFloat {
        if abs(height - halfWayPoint) < 30 {
            return halfWayPoint
        }
        return height
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, update edgeInsets: UIEdgeInsets, forBottomViewController bottomVC: UIViewController) {
    }
    
    // MARK: ISHPullUpStateDelegate
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, didChangeTo state: ISHPullUpState) {
        handleView.setState(ISHPullUpHandleView.handleState(for: state), animated: firstAppearanceCompleted)
    }
    
}

class ModalViewController: UIViewController {
    
    @IBAction func buttonTappedDone(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
