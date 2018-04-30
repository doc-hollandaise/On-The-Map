//
//  ViewController.swift
//  On The Map
//
//  Created by Derek Justus on 3/20/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alertUser(withMessage message:String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true, completion: nil)
    }


}

