//
//  RegisterPopupView.swift
//  Demo
//
//  Created by Shinji Hayashi on 2018/03/03.
//  Copyright © 2018年 shin884. All rights reserved.
//

import UIKit
import PopupWindow

class RegisterPopupView: UIView, PopupViewContainable, Nibable, UITableViewDataSource, UITableViewDelegate  {
    enum Const {
        static let height: CGFloat = 369
    }
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            closeButton.setImage(UIImage(named:"close"), for: .normal)
            closeButton.imageView?.tintColor = .gray
        }
    }
    
    var registerButtonTapHandler: (() -> Void)?
    var closeButtonTapHandler: (() -> Void)?
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.backgroundColor()
        addDropShadow(type: .dynamic, color: .black, opacity: 0.2, radius: 3, shadowOffset: CGSize(width: 0, height: 5))
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "MASwitchProfileTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        let nibMAAddProfileTableViewCell = UINib(nibName: "MAAddProfileTableViewCell", bundle: nil)
        tableView.register(nibMAAddProfileTableViewCell, forCellReuseIdentifier: "MAAddProfileTableViewCell")
        
    }
    
    @IBAction func didTapRegisterButton() {
        registerButtonTapHandler?()
    }
    
    @IBAction func didTapCloseButton() {
        closeButtonTapHandler?()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell! = nil
        if indexPath.row == 2 {
            let cellAddProfile  = tableView.dequeueReusableCell(withIdentifier: "MAAddProfileTableViewCell", for: indexPath) as! MAAddProfileTableViewCell
             cell = cellAddProfile
            
        }else{
            let cellSwitchProfile  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MASwitchProfileTableViewCell
            cellSwitchProfile.profileImage.image = UIImage(named: "iconDigiD")
            cellSwitchProfile.profileName.text = "Daniel Tcacenco"
            
            cell = cellSwitchProfile
        }
        return cell
    }
    
    
}
