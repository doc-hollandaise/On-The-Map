//
//  ConfirmPinViewController.swift
//  On The Map
//
//  Created by Derek Justus on 4/25/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import UIKit
import MapKit


class ConfirmPinViewController : ViewController, MKMapViewDelegate {
    var pin: CLLocation!
    var pinString: String?
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func postPin(_ sender: Any) {
       
        let location = StudentLocation(firstName: "Derek", lastName: "J", longitude: pin.coordinate.longitude, latitude: pin.coordinate.latitude, mediaURL: urlTextField.text!, objectID: nil, mapString: pinString)
         let broker = DataBroker()
        broker.postPin(atLocation: location, completionHandler: { success, error in
            if success {
                self.returnToMap()
            }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pin = pin {
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: pin.coordinate.latitude, longitude: pin.coordinate.longitude)
            annotation.coordinate = coordinate
   
            self.mapView.addAnnotation(annotation)
        }
    }

    
    func returnToMap() {
        if let vc = self.navigationController?.presentingViewController {
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
}
