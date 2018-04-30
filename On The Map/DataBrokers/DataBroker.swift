//
//  DataBroker.swift
//  On The Map
//
//  Created by Derek Justus on 3/22/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import Foundation
import CoreLocation

struct UDAccount : Codable {
    
}

struct UDSession : Codable {
    
}

struct LoginResponse : Codable{
    let status: Int?
    let error: String?
    let account: UDAccount?
    let session: UDSession?
}



class DataBroker {
    
    func login(forUser user:User, completionHandler: @escaping (_ success:Bool, _ error: String?) -> Void) {
        
        let loginString = "{\"udacity\": {\"username\": \"\(user.username)\", \"password\": \"\(user.password)\"}}"
        
        
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = loginString.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completionHandler(false, error?.localizedDescription)
                return
            }
            let range = Range(5..<data!.count)
            if let newData = data?.subdata(in: range) {
                
                let decoder = JSONDecoder()
                do {
                    let ourResponse = try decoder.decode(LoginResponse.self, from: newData)
                    if let responseError = ourResponse.error {
                        completionHandler(false, responseError.description)
                    } else {
                        completionHandler(true, nil)
                    }
                    print("What")
                } catch {
                    print("error trying to convert data to JSON")
                    print(error)
                    
                }
            }
        }
        task.resume()
    }
    
    func fetchPins(completionHandler: @escaping (_ pins:Array<StudentLocation>?, _ error: String?    ) -> Void)  {
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completionHandler(nil, error?.localizedDescription)
                return
            }
            
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                let results = RequestResult.init(results: parsedResult["results"] as! [AnyObject])
                var locations:Array<StudentLocation> = Array()
                for dict in results.results {
                    
                    let pin = StudentLocation.init(fromJson: dict as! Dictionary<String, Any>)
                    locations.append(pin)
                    
                }
                completionHandler(locations, nil)
                
            } catch {
                completionHandler(nil, "There was an error processing the result.")
            }
            
        }
        task.resume()
    }
    
    
    func postPin(atLocation location: StudentLocation, completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void)  {
        
        if let first = location.firstName, let last = location.lastName, let mapString = location.mapString, let media = location.mediaURL, let lat = location.latitude, let long = location.longitude {
        
            let bodyString = "{\"uniqueKey\": \"patryn0\", \"firstName\": \"\(first)\", \"lastName\": \"\(last)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(media)\",\"latitude\": \(lat), \"longitude\": \(long)}"
        
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = bodyString.data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completionHandler(false, error?.localizedDescription)
                return
            }
            
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
               print(String(data: data!, encoding: .utf8)!)
                
                completionHandler(true, nil)
                
            } catch {
            //    completionHandler(nil, "There was an error processing the result.")
            }
            
        }
        task.resume()
        } else {
            print("Invalid info")
        }
    }
}
