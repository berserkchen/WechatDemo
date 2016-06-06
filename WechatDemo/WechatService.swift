//
//  WechatService.swift
//  WechatDemo
//
//  Created by chaoyang805 on 16/5/31.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

protocol WechatServiceDelegate: class {
    func onServiceDidReceiveJSONResponse(json: JSON, withError error: NSError?)
}

class WechatService: NSObject {
    
    
    static let BaseURL = "http://172.16.12.50/WechatServer/"
    
    static weak var delegate: WechatServiceDelegate?
    
    class func login(userName: String, userEmail: String, userPassword: String, completionHandler handler: (JSON) -> Void) {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())

        let request = NSMutableURLRequest(URL: (BaseURL + "login.php").toURL()!)
        request.timeoutInterval = 10
        request.HTTPMethod = "POST"
        let params = "user_name=\(userName)&user_email=\(userEmail)&user_password=\(userPassword)"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            if let data = data {
                let json = JSON(data: data)
                handler(json)
            }
        }
        task.resume()
    }
    
    class func getUserInfo(userId: String, completionHandler handler: (JSON) -> Void) {
    
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let request = NSMutableURLRequest(URL: (BaseURL + "users.php").toURL()!)
        request.HTTPMethod = "POST"
        let params = "user_id=\(userId)"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            if let data = data {
            
                let json = JSON(data: data)
                
                if json == nil {
                    NSLog("json == nil")
                }
                handler(json)
            }
        }
        task.resume()
        
    }
}

extension String {
    func toURL() -> NSURL? {
        return NSURL(string: self)
    }
}
