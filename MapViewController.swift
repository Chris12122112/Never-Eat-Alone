//
//  MapViewController.swift
//  NEA4
//
//  Created by Chris Wang on 1/21/17.
//  Copyright © 2017 Chris Wang. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var annotationSubtitle: String?
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, annotationSubtitle: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.annotationSubtitle = annotationSubtitle
    }
}

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    // Log out
    @IBAction func logout(_ sender: Any) {
        print("Signing out")
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            performSegue(withIdentifier: "logoutSegue", sender: self)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        let latitude: CLLocationDegrees = 34.021808
        let longitude: CLLocationDegrees = -118.2858837
        let latDelta: CLLocationDegrees = 0.013
        let lonDelta: CLLocationDegrees = 0.013
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        mapView.setRegion(region, animated: true)
        
        // Add PKS Annotation
        let locationPKS = CLLocationCoordinate2DMake(34.0188189, -118.2910682)
        let PKSAnnotation = MKPointAnnotation()
        PKSAnnotation.title = "Parkside"
        PKSAnnotation.subtitle = "Number of people:"
        PKSAnnotation.coordinate = locationPKS
        mapView.addAnnotation(PKSAnnotation)
        
        // Add EVK Annotation
        let locationEVK = CLLocationCoordinate2DMake(34.0212407, -118.2820343)
        let EVKAnnotation = MKPointAnnotation()
        EVKAnnotation.title = "EVK"
        EVKAnnotation.subtitle = "Number of people:"
        EVKAnnotation.coordinate = locationEVK
        mapView.addAnnotation(EVKAnnotation)
        
        // Add 84 Annotation
        let locationE4 = CLLocationCoordinate2DMake(34.0247566, -118.2880902)
        let E4Annotation = MKPointAnnotation()
        E4Annotation.title = "Café 84"
        E4Annotation.subtitle = "Number of people:"
        E4Annotation.coordinate = locationE4
        mapView.addAnnotation(E4Annotation)

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "identifier"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
            print(annotationView?.annotation)
            
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "toLocationDescription", sender: self)
        let annotationThatWasTapped = view.annotation!.title
        print(annotationThatWasTapped)
        
        guard let tappedAnnotationNameFirstUnwrapping = annotationThatWasTapped else {
            print("Error in the first unwrapping of annotationThatWasTapped")
            return
        }
        
        guard let tappedAnnotationNameSecondUnwrapping = tappedAnnotationNameFirstUnwrapping else {
            print("Error in the second unwrapping of annotationThatWasTapped")
            return
        }
        
        Constants.eatingEstablishmentThatWasSelected = tappedAnnotationNameSecondUnwrapping
        print(Constants.eatingEstablishmentThatWasSelected)
    }
}
