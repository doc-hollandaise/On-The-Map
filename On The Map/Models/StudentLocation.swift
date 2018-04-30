//
//  StudentLocation.swift
//  On The Map
//
//  Created by Derek Justus on 3/21/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import Foundation


struct StudentLocation : Codable {
    let firstName: String?
    let lastName: String?
    let longitude: Double?
    let latitude: Double?
    let mediaURL: String?
    let objectID: String?
    let mapString: String?
}

extension StudentLocation  {
    
    init(fromJson dict:Dictionary<String,Any>) {
        self.latitude = dict["latitude"] as? Double
        self.longitude = dict["longitude"] as? Double
        self.firstName = dict["firstName"] as? String ?? ""
        self.lastName = dict["lastName"] as? String ?? ""
        self.mediaURL = dict["mediaURL"] as? String ?? ""
        self.objectID = dict["objectID"] as? String ?? ""
        self.mapString = dict["mapString"] as? String ?? ""
    }
    
}
