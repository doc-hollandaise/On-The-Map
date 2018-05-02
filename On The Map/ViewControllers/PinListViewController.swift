//
//  PinListViewController.swift
//  On The Map
//
//  Created by Derek Justus on 4/27/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import UIKit
import MapKit


class PinListViewController : ViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var pinTableView: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    
    @IBAction func logout(_ sender: Any) {
        startSpinner()
        let broker = DataBroker()
        broker.logout(completionHandler: {success, error in
            performUIUpdatesOnMain {
                self.stopSpinner()
                if success {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                } else {
                    self.alertUser(withMessage: error ?? "Unknown Error")
                }
            }
        })
    }
    
    @IBAction func addPin(_ sender: Any) {
        if let nc = self.storyboard?.instantiateViewController(withIdentifier: "AddPinNC") {
            self.present(nc, animated: true, completion: nil)
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        startSpinner()
        let broker = DataBroker()
        broker.fetchPins(completionHandler: {(pins, error) in
            
            
            if let err = error {
                self.stopSpinner()
                self.alertUser(withMessage: err)
                return
            }
            
            performUIUpdatesOnMain {
                 self.stopSpinner()
                DataModel.sharedInstance.pins = pins
                self.pinTableView.reloadData()
            }
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.activityView.activityIndicatorViewStyle = .gray
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DataModel.sharedInstance.pins!.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pinCell") as! UITableViewCell
        if let pins = DataModel.sharedInstance.pins {
            let pin = pins[indexPath.row]
            if let first = pin.firstName, let last = pin.lastName, let url = pin.mediaURL {
                cell.textLabel?.text = "\(first) \(last)"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let pins = DataModel.sharedInstance.pins {
            let pin = pins[indexPath.row]
            let app = UIApplication.shared
            if let pinURL = pin.mediaURL {
                
                guard let url = URL(string: pinURL) else {
                    let alert = UIAlertController(title: "Uh Oh", message: "This entry has a bad URL. Please try another.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                app.openURL(url)
                
            }
        }
    }
    
}
