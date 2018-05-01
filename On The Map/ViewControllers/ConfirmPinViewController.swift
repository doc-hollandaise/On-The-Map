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
    var appDelegate: AppDelegate!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func postPin(_ sender: Any) {
        startSpinner()
        if let info = appDelegate.memberInfo {
            let location = StudentLocation(firstName: "\(info.first_name)", lastName: "\(info.last_name)", longitude: pin.coordinate.longitude, latitude: pin.coordinate.latitude, mediaURL: urlTextField.text!, objectID: nil, mapString: pinString)
             let broker = DataBroker()
                broker.postPin(atLocation: location, completionHandler: { success, error in
                self.stopSpinner()
                if success {
                    self.returnToMap()
                }
                
            })
        }
    }
    @IBAction func dismiss(_ sender: Any) {
        returnToMap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate  as? AppDelegate
        
        mapView.showsUserLocation = true
        
        if let pin = pin {
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: pin.coordinate.latitude, longitude: pin.coordinate.longitude)
            annotation.coordinate = coordinate
            
            self.mapView.addAnnotation(annotation)
            
            zoomOn(coordinate: coordinate)
            
        }
    }
    
    func zoomOn(coordinate: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let mapRegion = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(mapRegion, animated: true)
      
    }

    
    func returnToMap() {
        if let vc = self.navigationController?.presentingViewController {
            vc.dismiss(animated: true, completion: nil)
        }
    }   
    
}

extension ConfirmPinViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}
