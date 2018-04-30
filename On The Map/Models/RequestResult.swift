//
//  RequestResult.swift
//  On The Map
//
//  Created by Derek Justus on 3/21/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import Foundation

struct RequestResult {
    var results: Array<Any>
}

extension RequestResult  {

    init(results json:Array<AnyObject>) {

           results = json
        }

}

