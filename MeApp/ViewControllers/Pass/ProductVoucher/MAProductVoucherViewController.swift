//
//  MAProductVoucherViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 10/15/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit
import Presentr
import SafariServices
import MapKit
import MarqueeLabel
import MessageUI

class MAProductVoucherViewController: MABaseViewController, SFSafariViewControllerDelegate {
    @IBOutlet weak var organizationIcon: UIImageView!
    @IBOutlet weak var organizationName: UILabel!
    @IBOutlet weak var organizationAddress: UILabel!
    @IBOutlet weak var telephoneNumber: UILabel!
    @IBOutlet weak var organizationEmailAddress: UIButton!
    @IBOutlet weak var voucherTitleLabel: MarqueeLabel!
    @IBOutlet weak var infoButton: ShadowButton!
    @IBOutlet weak var timAvailabelLabel: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var organizationLabel: UILabel!
    var latitude: Double!
    var long: Double!
    @IBOutlet weak var imageBodyView: UIImageView!
    var voucher: Voucher!
    @IBOutlet weak var mapView: MKMapView!
    var transactions: NSMutableArray! = NSMutableArray()
    @IBOutlet weak var kindPaketQRView: UIView!
    @IBOutlet weak var imageQR: UIImageView!
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
    
    func setupView() {
        if voucher.found.url_webshop == nil {
            self.infoButton.isHidden = true
        }
        organizationLabel.text = voucher.found.organization.name
        imageBodyView.layer.shadowColor = UIColor.black.cgColor
        imageBodyView.layer.shadowOffset = CGSize(width: 0, height: 5)
        imageBodyView.layer.shadowOpacity = 0.1
        imageBodyView.layer.shadowRadius = 10.0
        imageBodyView.clipsToBounds = false
        organizationAddress.text = voucher.offices?.first?.address
        telephoneNumber.text = voucher.offices?.first?.phone ?? "No phone number".localized()
        organizationEmailAddress.setTitle(voucher.offices?.first?.organization.email, for: .normal)
        
        self.voucherTitleLabel.text = voucher.product?.name
        voucherTitleLabel.type = .continuous
        self.priceLabel.text = "€ " + (voucher.amount)!
        imageQR.generateQRCode(from: "{\"type\": \"voucher\",\"value\": \"\(voucher.address!)\" }")
        organizationName.text = voucher.product?.organization.name
        
        if voucher.product?.organization.logo != nil{
            organizationIcon.sd_setImage(with: URL(string: voucher.product?.organization.logo.sizes?.thumbnail ?? ""), placeholderImage: UIImage(named: "Resting"))
        }else{
            organizationIcon.image = UIImage(named: "Resting")
        }
        if let latitudeValue = self.voucher.offices?.first?.lat, let lat = Double(latitudeValue) {
            latitude = lat
        }
        
        if voucher.offices?.first?.phone == nil {
            phoneButton.isHidden = true
        }
        
        if let longitudeValue = self.voucher.offices?.first?.lon, let lon = Double(longitudeValue) {
            long = lon
        }
        imageBodyView.isUserInteractionEnabled = true
        imageBodyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToQRReader)))
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToMap)))
        
        //organizationLabel gesture
        organizationEmailAddress.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(Tap)))
        organizationEmailAddress.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(Long)))
        
        let viewRegion = MKCoordinateRegionMakeWithDistance( CLLocationCoordinate2D(latitude:latitude , longitude: long), 5000, 5000)
        self.mapView.setRegion(viewRegion, animated: false)
        mapView.region = viewRegion
        self.mapView.addAnnotation(setAnnotation(lattitude: latitude, longitude: long))
    }
    
    @objc func Tap() {
        
        AlertController.showAlertActions(vc: self,
                                         title: "E-mail to me".localized(),
                                         detail: "Send the voucher to your email?".localized(),
                                         cancelTitle: "Cancel".localized(),
                                         confirmTitle: "Confirm".localized())
        { (action) in
            VoucherRequest.sendEmailToVoucher(address: self.voucher.address, completion: { (statusCode) in
                if MFMailComposeViewController.canSendMail() {
                    let composeVC = MFMailComposeViewController()
                    composeVC.mailComposeDelegate = self
                    composeVC.setToRecipients([(self.voucher.offices?.first?.organization.email)!])
                    composeVC.setSubject("Question from Me user".localized())
                    composeVC.setMessageBody("", isHTML: false)
                    self.present(composeVC, animated: true, completion: nil)
                }else{
                    AlertController.showWarning(withText: "Mail services are not available".localized(), vc: self)
                }
            }) { (error) in }
        }
     
    }
    
    @objc func Long() {
        UIPasteboard.general.string = self.voucher.offices?.first?.organization.email
        self.showSimpleToast(message: "Copied to clipboard".localized())
    }
    
    @objc func goToMap(){
        let actionSheet = UIAlertController.init(title: "Address".localized(), message: nil, preferredStyle: .actionSheet)
        
        //open apple maps
        actionSheet.addAction(UIAlertAction.init(title: "Open in Apple Maps", style: UIAlertActionStyle.default, handler: { (action) in
            
            self.openMapForPlace(lattitude: self.latitude, longitude: self.long)
        }))
        
        //open google maps
        actionSheet.addAction(UIAlertAction.init(title: "Open in Google Maps", style: UIAlertActionStyle.default, handler: { (action) in
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
            {
                UIApplication.shared.open(URL(string:
                    "comgooglemaps://?saddr=&daddr=\(self.latitude!),\(self.long!)&directionsmode=driving")!, options: [:], completionHandler: { (succes) in
                })
            } else if (UIApplication.shared.canOpenURL(URL(string:"https://maps.google.com")!))
            {
                UIApplication.shared.open(URL(string:
                    "https://maps.google.com/?q=@\(self.latitude!),\(self.long!)")!, options: [:], completionHandler: { (succes) in
                })
            }
        }))
        
        //copy to clipboard
        actionSheet.addAction(UIAlertAction.init(title: "Copy address".localized(), style: UIAlertActionStyle.default, handler: { (action) in
            UIPasteboard.general.string = self.voucher.offices?.first?.address
            self.showSimpleToast(message: "Copied to clipboard".localized())
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Cancel".localized(), style: UIAlertActionStyle.cancel, handler: { (action) in
        }))
        //Present the controller
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func goToQRReader(){
        NotificationCenter.default.post(name: Notification.Name("togleStateWindow"), object: nil)
    }
    
    @IBAction func callPhone(_ sender: Any) {
        guard let number = URL(string: "tel://" + (voucher.offices?.first?.phone!)!) else { return }
        UIApplication.shared.open(number)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true

    }
    
    @IBAction func showEmailToMe(_ sender: Any) {
        AlertController.showAlertActions(vc: self,
                                         title: "E-mail to me".localized(),
                                         detail: "Send the voucher to your email?".localized(),
                                         cancelTitle: "Cancel".localized(),
                                         confirmTitle: "Confirm".localized())
        { (action) in
            VoucherRequest.sendEmailToVoucher(address: self.voucher.address, completion: { (statusCode) in
                let popupTransction = MARegistrationSuccessViewController(nibName: "MARegistrationSuccessViewController", bundle: nil)
                self.presenter.presentationType = .popup
                self.presenter.transitionType = nil
                self.presenter.dismissTransitionType = nil
                self.presenter.keyboardTranslationType = .compress
                self.customPresentViewController(self.presenter, viewController: popupTransction, animated: true, completion: nil)
            }) { (error) in }
        }
    }
    
    @IBAction func showInfo(_ sender: Any) {
        let safariVC = SFSafariViewController(url: URL(string: voucher.found.url_webshop! + "product/\(voucher.product?.id! ?? 0)")!)
        safariVC.delegate = self
        self.present(safariVC, animated: true, completion: nil)
    }
}

extension MAProductVoucherViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        let reuseId = "annotation"
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView?.canShowCallout = true
        }
        else {
            anView?.annotation = annotation
        }
        let cpa = annotation as! CustomPointAnnotation
        anView?.image = UIImage(named:cpa.imageName)
        
        return anView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circle = MKCircleRenderer(overlay: overlay)
        circle.strokeColor = #colorLiteral(red: 0.3073092699, green: 0.4766488671, blue: 0.9586974978, alpha: 1)
        circle.fillColor = #colorLiteral(red: 0.746714294, green: 0.8004079461, blue: 0.9871394038, alpha: 0.7)
        circle.lineWidth = 1
        return circle
    }
}

extension MAProductVoucherViewController{
    
    func setAnnotation(lattitude: Double, longitude: Double) -> CustomPointAnnotation{
        let annotation = CustomPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(lattitude, longitude)
        annotation.imageName = "carLocation"
        return annotation
    }
    
    func openMapForPlace(lattitude: Double, longitude: Double) {
        
        let latitude: CLLocationDegrees = lattitude
        let longitude: CLLocationDegrees = longitude
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Address Name"
        mapItem.openInMaps(launchOptions: options)
    }
}

extension MAProductVoucherViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}


class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}
