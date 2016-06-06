//
//  LoginViewController.swift
//  WechatDemo
//
//  Created by chaoyang805 on 16/5/31.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: class {
    func loginViewController(controller: LoginViewController, didFetchUserData userInfos: [String : RCUserInfo])
    func loginViewControllerDidLogin(controller: LoginViewController)
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    weak var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.text = "zhangchaoyang805"
        userEmailTextField.text = "zhangchaoyang805@gmail.com"
        userPasswordTextField.text = "zcy252570540"
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonDidTouch(sender: UIButton) {
        guard let userName = userNameTextField.text, userEmail = userEmailTextField.text, userPassword = userPasswordTextField.text where (!userName.isEmpty) && (!userEmail.isEmpty) && (!userPassword.isEmpty) else { return }
        WechatService.login(userName, userEmail: userEmail, userPassword: userPassword) { (json: JSON) in
            let token = json["token"].string ?? ""
            let userId = json["userId"].string ?? ""
            let code = json["code"].int ?? 0
            if(code == 200) {
                LocalStore.saveToken(token)
                LocalStore.saveUserId(userId)
                // TODO 登录成功
                dispatch_sync(dispatch_get_main_queue(), {
                    self.delegate?.loginViewControllerDidLogin(self)
                    self.fetchUsers()
                })
            }
        }
        
    }

    func fetchUsers() {
        guard let _ = LocalStore.getToken(), userId = LocalStore.getUserId() else { return }
        var userInfos = [String : RCUserInfo]()
        WechatService.getUserInfo(userId) { (json: JSON) in
            
            for index in 0..<json.count {
                
                let userInfo = self.parseUserInfo(json[index])
                userInfos[userInfo.userId] = userInfo
            }
            self.delegate?.loginViewController(self, didFetchUserData: userInfos)
            
        }
        
    }
    
    func parseUserInfo(json: JSON) -> RCUserInfo {
        let userId = json["user_id"].string ?? ""
        let userName = json["user_name"].string ?? ""
        let userImageUri = json["user_image_uri"].string ?? ""
        
        let userInfo = RCUserInfo(userId: userId, name: userName, portrait: userImageUri)
        return userInfo
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
