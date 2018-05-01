//
//  LoginViewController.swift
//  On The Map
//
//  Created by Derek Justus on 3/20/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import UIKit

struct LoginInfo : Codable {
    let username:String
    let password:String
}

struct User : Codable {
    let user: UserInfo
}

struct UserInfo : Codable {
    let first_name: String
    let last_name: String
}




class LoginViewController : ViewController {
    
     var appDelegate: AppDelegate!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          appDelegate = UIApplication.shared.delegate as? AppDelegate
    }
    
    @IBAction func login(_ sender: Any) {
        
        dismissKeyboard()
        
        startSpinner()
        
    //   let user = LoginInfo(username: self.userNameTextField.text!, password: self.passwordTextField.text!)
         let user = LoginInfo(username: "patryn0@gmail.com", password: "war45036")
        
        let broker = DataBroker()
        broker.login(forUser: user, completionHandler: { (success, error, account) in
            if success {
                if  let account = account, let key = account.key {
                    self.getUserInfoForUser(ID: key)
                }
            } else {
                self.stopSpinner()
              self.alertUser(withMessage: error ?? "Unknown Error")
            }
        })
    }
    
    func getUserInfoForUser(ID: String) {
       let broker = DataBroker()
        broker.getUserInfo(usingID: ID, completionHandler: { (success, error, userInfo) in
            if success {
               let info = userInfo
               self.appDelegate.memberInfo = info
               self.fetchPins()   
            } else {
                self.stopSpinner()
                self.alertUser(withMessage: error ?? "Unknown Error")
            }
        })
    }
    
    func fetchPins() {
        let broker = DataBroker()
        broker.fetchPins(completionHandler: {(pins, error) in
            
            if let err = error {
                self.alertUser(withMessage: err)
                return
            }
            
            performUIUpdatesOnMain {
                self.stopSpinner()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.pins = pins
                
                if let tabBar = self.storyboard?.instantiateViewController(withIdentifier: "TabBar"), let nc = self.navigationController {
                    nc.pushViewController(tabBar, animated: true)
                } else {
                    fatalError("Missing key storyboard elements")                    
                }

            }
        })
    }
    
    func dismissKeyboard() {
        self.userNameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}
