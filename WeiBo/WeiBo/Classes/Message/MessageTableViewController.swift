//
//  MessageTableViewController.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/7/26.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

class MessageTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isLoging {
            visitorView?.setupVisitorViewInfo("visitordiscover_image_message", title: "登录后，别人评论你的微博，发送给你的消息，都会在这里收到通知")
        }
    }

    
}
