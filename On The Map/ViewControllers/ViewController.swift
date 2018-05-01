//
//  ViewController.swift
//  On The Map
//
//  Created by Derek Justus on 3/20/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var activityView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityView()
    }
    
    func setupActivityView() {
        activityView = UIActivityIndicatorView(frame: self.view.frame)
        activityView.activityIndicatorViewStyle = .whiteLarge
        activityView.hidesWhenStopped = true
        activityView.isHidden = true
        view.addSubview(activityView)
        view.bringSubview(toFront: activityView)
        
    }
    
    func startSpinner() {
        activityView.isHidden = false
        activityView.startAnimating()
    }
    
    func stopSpinner() {
        activityView.stopAnimating()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alertUser(withMessage message:String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


}

