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

class MAProductVoucherViewController: MABaseViewController, SFSafariViewControllerDelegate {
    @IBOutlet weak var organizationIcon: UIImageView!
    @IBOutlet weak var organizationName: UILabel!
    @IBOutlet weak var organizationAddress: UILabel!
    @IBOutlet weak var telephoneNumber: UILabel!
    @IBOutlet weak var organizationEmailAddress: UIButton!
    @IBOutlet weak var voucherTitleLabel: UILabel!
    @IBOutlet weak var timAvailabelLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
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
        imageBodyView.layer.shadowColor = UIColor.black.cgColor
        imageBodyView.layer.shadowOffset = CGSize(width: 0, height: 5)
        imageBodyView.layer.shadowOpacity = 0.1
        imageBodyView.layer.shadowRadius = 10.0
        imageBodyView.clipsToBounds = false
        self.voucherTitleLabel.text = voucher.product?.name
        self.priceLabel.text = "€ " + (voucher.product?.price)!
        imageQR.generateQRCode(from: "{ \"type\": \"voucher\",\"value\": \"\(voucher.address!)\" }")
        organizationName.text = voucher.product?.organization.name
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToQRReader))
        imageQR.isUserInteractionEnabled = true
        imageQR.addGestureRecognizer(tapGestureRecognizer)
        let tapGestureRecognizerMap = UITapGestureRecognizer(target: self, action: #selector(goToMap))
        mapView.addGestureRecognizer(tapGestureRecognizerMap)
    }
    
    @objc func goToMap(){
        self.performSegue(withIdentifier: "goToMap", sender: nil)
    }
    
    @objc func goToQRReader(){
        NotificationCenter.default.post(name: Notification.Name("togleStateWindow"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        let circle = MKCircle(center: CLLocationCoordinate2D(latitude:47.0571 , longitude: 28.8941),
            radius: 1000 as CLLocationDistance)
        let viewRegion = MKCoordinateRegionMakeWithDistance( CLLocationCoordinate2D(latitude:47.0571 , longitude: 28.8941), 5000, 5000)
        self.mapView.setRegion(viewRegion, animated: false)
        mapView.region = viewRegion
        self.mapView.add(circle)
        self.mapView.addAnnotation(setAnnotation(lattitude: 47.0571, longitude: 28.8941))
    }
  
    
    @IBAction func showEmailToMe(_ sender: Any) {
        VoucherRequest.sendEmailToVoucher(address: voucher.address, completion: { (statusCode) in
            let popupTransction =  MARegistrationSuccessViewController(nibName: "MARegistrationSuccessViewController", bundle: nil)
            self.presenter.presentationType = .popup
            self.presenter.transitionType = nil
            self.presenter.dismissTransitionType = nil
            self.presenter.keyboardTranslationType = .compress
            self.customPresentViewController(self.presenter, viewController: popupTransction, animated: true, completion: nil)
        }) { (error) in
            
        }
    }
    
    @IBAction func showInfo(_ sender: Any) {
        let safariVC = SFSafariViewController(url: URL(string: "https://www.zuidhorn.nl/kindpakket")!)
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
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
}


class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}
