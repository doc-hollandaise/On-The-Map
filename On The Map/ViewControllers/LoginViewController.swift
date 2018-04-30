//
//  LoginViewController.swift
//  On The Map
//
//  Created by Derek Justus on 3/20/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import UIKit

struct User : Codable {
    let username:String
    let password:String
}

//extension User {
//    func infoAs(string:String) -> String {
//        let string = (
//    }
//}

class LoginViewController : ViewController {
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func login(_ sender: Any) {
       let user = User(username: "patryn0@gmail.com", password: "war45036")
        
        let broker = DataBroker()
        broker.login(forUser: user, completionHandler: { (success, error) in
            if success {
               self.fetchPins()
            } else {
             print(error ?? "Unknown Error")
            }
            })
    }
    
    func fetchPins() {
        let broker = DataBroker()
        broker.fetchPins(completionHandler: {(pins, error) in
            performUIUpdatesOnMain {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.pins = pins
                self.performSegue(withIdentifier: "MoveToTabBar", sender: self)
            }
        })
    }
    
}
