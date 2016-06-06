//
//  UIViewController+SetTabBarVisible.swift
//  WechatDemo
//
//  Created by chaoyang805 on 16/6/6.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import Foundation
extension UIViewController {
    func setTabBarVisible(visible: Bool, animated: Bool, completion:((Bool)->Void)?) {
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) {
            completion?(true)
            return
        }
        
        // get a frame calculation ready
        guard let tabBarController = tabBarController else { return }
        let height = tabBarController.tabBar.frame.size.height
        let offsetY = (visible ? -height : height)
        
        // zero duration means no animation
        let duration = (animated ? 0.3 : 0.0)
        
        UIView.animateWithDuration(duration, animations: {
            let frame = tabBarController.tabBar.frame
            tabBarController.tabBar.frame = CGRectOffset(frame, 0, offsetY);
            }, completion:completion)
    }
    
    func tabBarIsVisible() -> Bool {
        if let tabBarController = tabBarController {
            
            return tabBarController.tabBar.frame.origin.y < CGRectGetMaxY(view.frame)
        } else {
            
            return false
        }
    }
}