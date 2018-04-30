//
//  MapViewController.swift
//  On The Map
//
//  Created by Derek Justus on 3/28/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import UIKit
import MapKit

class MapViewController : ViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
     var locations: Array<StudentLocation>?
    var appDelegate: AppDelegate?
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    
    @IBAction func addPin(_ sender: Any) {
        if let nc = self.storyboard?.instantiateViewController(withIdentifier: "AddPinNC") {
            self.present(nc, animated: true, completion: nil)
        }
    }
    @IBAction func refreshPins(_ sender: Any) {
    
            self.mapView.removeAnnotations(mapView.annotations)
            
            let broker = DataBroker()
            broker.fetchPins(completionHandler: {(pins, error) in
                performUIUpdatesOnMain {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.pins = pins
                    self.locations = appDelegate.pins
                    self.updateMap()
                }
            })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        locations = appDelegate?.pins
        updateMap()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshPins(self)
    }
    
    func updateMap() {
        if let newLocations = locations {
            let pins = getAnnotations(fromLocations: newLocations)
            self.mapView.addAnnotations(pins)
        }
    }
    
    func getAnnotations(fromLocations: Array<StudentLocation>) -> [MKPointAnnotation] {
        
        var annotations = [MKPointAnnotation]()
        for location in locations! {
            if let latitude = location.latitude, let longitude = location.longitude, let first = location.firstName, let last = location.lastName, let mediaURL = location.mediaURL {
                let lat = CLLocationDegrees(latitude)
                let long = CLLocationDegrees(longitude)
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                annotations.append(annotation)
            }
        }
        return annotations
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .green
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
             
                guard let url = URL(string: toOpen) else {
                        print("handle bad URL!")
                        return
                }
                 app.openURL(url)
               
            }
        }
    }

 
    
}
