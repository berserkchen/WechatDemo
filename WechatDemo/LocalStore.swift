//
//  LocalStore.swift
//  WechatDemo
//
//  Created by chaoyang805 on 16/6/1.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

struct LocalStore {
    static var userDefaults = NSUserDefaults.standardUserDefaults()
    
    private static var AppKey = "c9kqb3rdklf3j"
    
    static func appKey() -> String {
        return AppKey
    }
    
    static func getToken() -> String? {
        return stringForKey("tokenKey")
    }
    
    static func getUserId() -> String? {
        return stringForKey("userIdKey")
    }
    
    static func saveToken(token: String) {
        saveString(token, forKey: "tokenKey")
    }
    
    static func saveUserId(userId: String) {
        saveString(userId, forKey: "userIdKey")
    }
    
    static private func stringForKey(key: String) -> String? {
        return userDefaults.stringForKey(key)
    }
    
    static private func saveString(aString: String, forKey key: String) {
        userDefaults.setObject(aString, forKey: key)
    }
    
    
}