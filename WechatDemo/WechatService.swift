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
    
    
    static let BaseURL = "http://172.16.12.50/WechatServer"
    
    static weak var delegate: WechatServiceDelegate?
    
    private enum ResourcePath: CustomStringConvertible {
        case Login
        case Register
        case Friends
        case Users
        var description: String {
            switch self {
            case .Login:
                return "/login/index.php"
            case .Register:
                return "/register/index.php"
            case .Friends:
                return "/friends/index.php"
            case .Users:
                return "/users/index.php"
            }
        }
    }
    
    
    class func login(userName: String, userEmail: String, userPassword: String, completionHandler handler: (JSON) -> Void) {
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let urlString = BaseURL + ResourcePath.Login.description
        NSLog("login url:\(urlString)")
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.timeoutInterval = 10
        request.HTTPMethod = "POST"
        let params = "user_name=\(userName)&user_email=\(userEmail)&user_password=\(userPassword)"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            if let data = data {
                let dataStr = String(data: data, encoding: NSUTF8StringEncoding)
                NSLog("login:\(dataStr!)")
                let json = JSON(data: data)
                handler(json)
            }
        }
        task.resume()
    }
    
    class func getUserInfo(userId: String, completionHandler handler: (JSON) -> Void) {
    
        let urlString = BaseURL + ResourcePath.Users.description
        NSLog("users url:\(urlString)")
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        
        let params = "user_id=\(userId)"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            if let error = error {
                NSLog("users error:\(error)")
            }
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
    
    class func getFriendsWithUserId(userId: String, completionHandler handler: (JSON) -> Void) {
        let urlString = BaseURL + ResourcePath.Friends.description
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = "user_id=\(userId)".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        session.dataTaskWithRequest(request) { (data, response, error) in
    
            if let data = data {
                let dataStr = String(data: data, encoding: NSUTF8StringEncoding)
                NSLog("friends:%@", dataStr!)
                let json = JSON(data: data)
                if json == nil {
                    NSLog("json = nil")
                }
                handler(json)
            }
        }.resume()
    }
}

extension String {
    func toURL() -> NSURL? {
        return NSURL(string: self)
    }
}
