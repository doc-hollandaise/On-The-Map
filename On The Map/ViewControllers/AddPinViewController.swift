//
//  AddPinViewController.swift
//  On The Map
//
//  Created by Derek Justus on 4/25/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import UIKit
import MapKit


class AddPinViewController : ViewController {
    
    @IBOutlet weak var findButton: UIButton!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBAction func getGeoCode(_ sender: Any) {
        let coder = CLGeocoder()
        coder.geocodeAddressString(locationTextField.text!, completionHandler: { marks, error in
            
            var pin: CLLocation?
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
                
            if let marks = marks, let loc = marks.first?.location  {
                let coord = loc.coordinate
                pin = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
                performUIUpdatesOnMain {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmPinVC") as! ConfirmPinViewController
                  vc.pin = pin
                  vc.pinString = self.locationTextField.text!
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
            
            })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        
    }

}

extension AddPinViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    
}
