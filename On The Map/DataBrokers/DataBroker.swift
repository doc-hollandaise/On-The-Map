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
    let key: String?
    
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
    
    func login(forUser user:LoginInfo, completionHandler: @escaping (_ success:Bool, _ error: String?, _ account: UDAccount?) -> Void) {
        
        let loginString = "{\"udacity\": {\"username\": \"\(user.username)\", \"password\": \"\(user.password)\"}}"
        
        
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = loginString.data(using: .utf8)
        request.timeoutInterval = 10
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completionHandler(false, error?.localizedDescription, nil)
                return
            }
            let range = Range(5..<data!.count)
            if let newData = data?.subdata(in: range) {
                
                let decoder = JSONDecoder()
                do {
                    let ourResponse = try decoder.decode(LoginResponse.self, from: newData)
                    guard ourResponse.error == nil else {
                        completionHandler(false, "Invalid Credentials", nil)
                        return
                    }
                        completionHandler(true, nil, ourResponse.account)
  
                   
                } catch {
                   fatalError("error trying to convert data to JSON")
                    
                }
            }
        }
        task.resume()
    }
    
    func logout(completionHandler: @escaping (_ success:Bool, _ error: String?) -> Void) {
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completionHandler(false, error?.localizedDescription)
                return
            }
            
            completionHandler(true, nil)
           
        }
        task.resume()
    }
    
    func getUserInfo(usingID key: String, completionHandler: @escaping (_ success:Bool, _ error: String?, _ info: UserInfo?) -> Void) {
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/\(key)")!)
         request.timeoutInterval = 10
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                completionHandler(false, error?.localizedDescription, nil)
            }
          
           
            
            let range = Range(5..<data!.count)
            if let newData = data?.subdata(in: range) {
                 print(String(data: newData, encoding: .utf8)!)
            
                let decoder = JSONDecoder()
                do {
                    let ourResponse = try decoder.decode(User.self, from: newData)
                    completionHandler(true, nil, ourResponse.user)
                } catch {
                    fatalError("error trying to convert data to JSON")
                }
            }
            
        }
        task.resume()
    }
    
    func fetchPins(completionHandler: @escaping (_ pins:Array<StudentLocation>?, _ error: String?    ) -> Void)  {
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?order=-updatedAt&limit=100")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.timeoutInterval = 10
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completionHandler(nil, error?.localizedDescription)
                return
            }
            do {
               let parsedResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                 print(String(data: data!, encoding: .utf8)!)
                
               guard parsedResult
                .value(forKey: "results") != nil else {
                    completionHandler(nil, "There was an error processing the result.")
                    return
                }
                
                let resultJSON = parsedResult["results"]
                let results = RequestResult.init(results: resultJSON as! [AnyObject])
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
                completionHandler(false, "There was an error processing the result.")
            }
            
        }
        task.resume()
        } else {
            print("Invalid info")
        }
    }
}
