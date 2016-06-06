//
//  FriendsTableViewController.swift
//  WechatDemo
//
//  Created by chaoyang805 on 16/6/6.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class FriendsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let appDelegate = (UIApplication.sharedApplication().delegate) as? AppDelegate {
            self.tableView.registerClass(RCConversationCell.self, forCellReuseIdentifier: "ConversationCell")
            self.tableView.dataSource = appDelegate
            self.tableView.estimatedRowHeight = 100
            self.tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setTabBarVisible(true, animated: true, completion: nil)
    }
    
    // MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 67
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! RCConversationCell
        let chatViewController = RCConversationViewController(conversationType: cell.model.conversationType, targetId: cell.model.targetId)
        chatViewController.title = cell.model.conversationTitle
        setTabBarVisible(false, animated: true, completion: nil)
        self.navigationController?.pushViewController(chatViewController, animated: true)
        
    }
    
}
