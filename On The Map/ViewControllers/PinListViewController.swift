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
    
    var locations: Array<StudentLocation>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        locations = appDelegate?.pins
 
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locations.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pinCell") as! UITableViewCell
        let pin = locations[indexPath.row]
        if let first = pin.firstName, let last = pin.lastName, let url = pin.mediaURL {
            cell.textLabel?.text = "\(first) \(last)"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let pin = locations[indexPath.row]
        
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
