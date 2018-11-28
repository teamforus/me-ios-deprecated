//
//  MAMapViewViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 11/28/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit
import MapKit

class MAMapViewViewController: MABaseViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let circle = MKCircle(center: CLLocationCoordinate2D(latitude:47.0571 , longitude: 28.8941),
                              radius: 1000 as CLLocationDistance)
        let viewRegion = MKCoordinateRegionMakeWithDistance( CLLocationCoordinate2D(latitude:47.0571 , longitude: 28.8941), 7000, 7000)
        self.mapView.setRegion(viewRegion, animated: false)
        mapView.region = viewRegion
        self.mapView.add(circle)
        self.mapView.addAnnotation(setAnnotation(lattitude: 47.0571, longitude: 28.8941))
    }

}

extension MAMapViewViewController{
    
    func setAnnotation(lattitude: Double, longitude: Double) -> CustomPointAnnotation{
        let annotation = CustomPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(lattitude, longitude)
        annotation.imageName = "carLocation"
        return annotation
    }
}


extension MAMapViewViewController: MKMapViewDelegate{
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
