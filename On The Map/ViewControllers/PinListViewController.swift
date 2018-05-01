//
//  PinListViewController.swift
//  On The Map
//
//  Created by Derek Justus on 4/27/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import UIKit
import MapKit


class PinListViewController : UITableViewController {
    
    @IBOutlet var pinTableView: UITableView!
    var appDelegate: AppDelegate!
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
       
 
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return appDelegate.pins!.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pinCell") as! UITableViewCell
        if let pins = appDelegate.pins {
            let pin = pins[indexPath.row]
            if let first = pin.firstName, let last = pin.lastName, let url = pin.mediaURL {
                cell.textLabel?.text = "\(first) \(last)"
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let pins = appDelegate.pins {
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
