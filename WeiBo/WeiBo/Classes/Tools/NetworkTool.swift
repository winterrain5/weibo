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
    // MARK: 加载微博数据
    func loadStatuses(since_id:String,max_id:String, finished: (array :[[String: AnyObject]]?, error :NSError?)->()) {
        
        if UserAccountModel.loadUserAccount() == nil {
            
            
            
        }
        
        assert(UserAccountModel.loadUserAccount() != nil
            , "必须授权登录才能获取微博数据")
        
        let path = "2/statuses/home_timeline.json"
        
        
        let parameter = ["access_token":UserAccountModel.loadUserAccount()!.access_token!,"since_id":since_id,"max_id":max_id]
        
        GET(path, parameters:parameter, success: { (task, objc) -> Void in
     
            guard let arr = (objc as! [String: AnyObject])["statuses"] as? [[String: AnyObject]] else {
                
                finished(array: nil
                    , error: NSError(domain: "com.520it.lnj", code: 1000, userInfo: ["messages":"没有获取到数据"]))
                return
            }
            finished(array: arr, error: nil)
            }) { (task, error) -> Void in
            
                finished(array: nil, error: error)
        }
        
        
    }
}
