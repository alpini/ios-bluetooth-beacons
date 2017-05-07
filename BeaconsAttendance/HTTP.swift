//
//  HTTP.swift
//  SPREAD
//
//  Created by Vamsi Yechoor on 4/18/17.
//  Copyright © 2017 Vamsi Yechoor. All rights reserved.
//

import Foundation

class HTTP {
    
    static func post(urlS : String, params : [String: AnyObject], completion: @escaping ([String: AnyObject]) -> ()) {
        if let url = URL(string: urlS) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let stringParams = dictionaryToString(dictionary: params)
            request.httpBody = stringParams.data(using: String.Encoding.utf8, allowLossyConversion: true)
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                
                do{
                    if data != nil {
                        let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                        completion(parsedData)
                    }
                } catch let error as NSError {
                    print(error)
                }
                
            }
            task.resume()
        }
    }
    
    static func get(urlS: String, completion: @escaping ([String: AnyObject]) -> ()) {
        if let url = URL(string: urlS) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                
                do{
                    if data != nil {
                        let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                        completion(parsedData)
                    }
                } catch let error as NSError {
                    print(error)
                }
                
            }
            task.resume()
        }
    }
    
    private static func dictionaryToString(dictionary: [String: AnyObject]) -> String{
        var params = String()
        
        for (key, value) in dictionary {
            params += "&\(key)=\(value)"
        }
        params.remove(at: params.startIndex)
        
        return params
    }
}
