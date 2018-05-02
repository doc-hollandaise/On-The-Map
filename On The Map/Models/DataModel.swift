//
//  DataModel.swift
//  On The Map
//
//  Created by Derek Justus on 5/2/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import Foundation

final class DataModel {
    static let sharedInstance = DataModel()
    
    var pins : Array<StudentLocation>?
    
    private init() {}
}
