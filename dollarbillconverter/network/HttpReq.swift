//
//  File.swift
//  dollarbillconverter
//
//  Created by Diego Castaño on 9/1/16.
//  Copyright © 2016 Diego Castaño. All rights reserved.
//

import Foundation

/// Performs HTTP requests
class HttpReq {
    
    /**
     Sends an http request
     
     - Parameter request: the request object
     - Parameter callback: to be executed upon request completion
     */
    static func sendRequest(request: NSMutableURLRequest,callback: (String, String?) -> Void) {
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request,completionHandler :
            {
                data, response, error in
                if error != nil {
                    callback("", (error!.localizedDescription) as String)
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        callback(NSString(data: data!, encoding: NSUTF8StringEncoding) as! String,nil)
                    }
                }
        })
        
        task.resume() //Tasks are called with .resume()
        
    }
    
    /**
     Parse a JSON response to a Dictionary
     
     - Parameter jsonString: the string representation of the desired json
     
     - Return: A dictionary with the json structure
     */
    static func JSONParseDict(jsonString:String) -> JSONObject {
        
        if let data: NSData = jsonString.dataUsingEncoding(
            NSUTF8StringEncoding){
            
            do{
                if let jsonObj = try NSJSONSerialization.JSONObjectWithData(
                    data,
                options: NSJSONReadingOptions(rawValue: 0)) as? JSONObject {
                    return jsonObj
                }
            }catch{
                print("Error")
            }
        }
        return JSONObject()
    }
    
    /**
     Performs an http get request to an endpoint that return json data
     
     - Parameter url: the endpoint url
     - Parameter callback: to be executed upon request and json parsing completion
     */
    
    typealias JSONObject = [String: AnyObject]
    static func getJSON(url: String, callback: (JSONObject, String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        sendRequest(request) {
            (data: String, error: String?) -> Void in
            if error != nil {
                callback(JSONObject(), error)
            } else {
                let jsonObj = JSONParseDict(data)
                callback(jsonObj, nil)
            }
        }
    }
}
