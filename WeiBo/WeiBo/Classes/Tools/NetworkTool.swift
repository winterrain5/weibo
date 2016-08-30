//
//  NetworkTool.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/8/7.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit
import AFNetworking

class NetworkTool: AFHTTPSessionManager {
    
    // swift推荐这样编写单例
    static let shareInstance:NetworkTool = {
    
        let baseUrl = NSURL(string: "https://api.weibo.com/")
        let instance = NetworkTool(baseURL: baseUrl, sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        return instance
        
    }()
    
}
