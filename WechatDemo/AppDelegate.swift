//
//  AppDelegate.swift
//  WechatDemo
//
//  Created by chaoyang805 on 16/5/30.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LoginViewControllerDelegate, RCIMUserInfoDataSource, UITableViewDelegate, UITableViewDataSource {
    
    var window: UIWindow?
    
    let AppKey = "c9kqb3rdklf3j"
    let Token = "Lle+YYQoX1BzUJhu0vWScfYBLQE9lXJZCT3PXXbe33HGNhEgBm3+dnrPRopHPAlIWAfhWfINmzMy5ET7TeWDqQ=="
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        RCIM.sharedRCIM().initWithAppKey(AppKey)
        if let rootVC = self.window?.rootViewController as? LoginViewController {
            rootVC.delegate = self
        }
        return true
    }
    
    
    
    var userInfos: [String : RCUserInfo] = [:]
    var userInfosArray: [RCUserInfo] = []
    func initRCIM() {
        
        guard let token = LocalStore.getToken(), userId = LocalStore.getUserId() else { return }
        RCIM.sharedRCIM().connectWithToken(token, success: { (remoteId: String!) in
            if userId == remoteId {
                // 连接成功
//                guard let tabController = self.window?.rootViewController as? UITabBarController, naviController = tabController.selectedViewController as? UINavigationController, _ = naviController.topViewController as? WechatDemoListViewController else {
//                    return
//                }
                RCIM.sharedRCIM().userInfoDataSource = self
                
            }
            
            }, error: { (error) in
                NSLog("连接出错\(error)")
                // 连接出错
        }) {
            // token 错误
            NSLog("token 错误")
        }
        
    }
    
    func parseUserInfo(json: JSON) -> RCUserInfo {
        let userId = json["user_id"].string ?? ""
        let userName = json["user_name"].string ?? ""
        let userImageUri = json["user_image_uri"].string ?? ""
        
        let userInfo = RCUserInfo(userId: userId, name: userName, portrait: userImageUri)
        return userInfo
    }

    // MARK: RCIMUserInfoDataSource
    func getUserInfoWithUserId(userId: String!, completion: ((RCUserInfo!) -> Void)!) {
        NSLog("get user info")
        if let userInfo = userInfos[userId] {
            completion(userInfo)
        } else {
            let emptyUserInfo = RCUserInfo(userId: "", name: "神秘人", portrait: "")
            completion(emptyUserInfo)
        }
        
    }
    
    // MARK: LoginViewControllerDelegate
    func loginViewControllerDidLogin(controller: LoginViewController) {
        NSLog("Did login")
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        if let tabBarController = mainStoryBoard.instantiateViewControllerWithIdentifier("TabBarController") as? UITabBarController {
            self.window?.rootViewController = tabBarController
            
        }
        
    }
    func loginViewController(controller: LoginViewController, didFetchUserData userInfos: [String : RCUserInfo]) {
        NSLog("Did fetch data")
        self.userInfos = userInfos
        self.userInfosArray = userInfos.map{ $0.1 }
        self.initRCIM()
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ConversationCell") as! RCConversationCell
        let row = indexPath.row
        let conversation = RCConversation()
        let targetUser = userInfosArray[row]
        conversation.targetId = targetUser.userId
        conversation.conversationTitle = targetUser.name
        conversation.conversationType = RCConversationType.ConversationType_PRIVATE
        let model = RCConversationModel(.CONVERSATION_MODEL_TYPE_NORMAL, conversation: conversation, extend: nil)
        cell.setDataModel(model)
        
        return cell
    }
    
}

