//
//  StatuesViewModel.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/9/9.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

class StatuesViewModel: NSObject {

    var status:Status
    
    init(status:Status) {
        
        self.status = status
        
        // 会员等级
        mbrankImage = UIImage(named:"common_icon_membership_level\(self.status.user!.mbrank)")
        
        // 认证图片
        switch self.status.user?.verified_type ?? -1 {
            
        case 0 :
            verifiedImage = UIImage(named: "avatar_vip")
        case 2,3,5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = UIImage(named: "avatar_vgirl")
        }
        
        // 来源
        if let source:NSString = status.source where source != ""{
            
            let  startIndex = source.rangeOfString(">").location + 1
            let  length = source.rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startIndex
            let restultStr = source.substringWithRange(NSMakeRange(startIndex, length))
            source_str = "来自：\(restultStr)"
        }
        
        // 时间
        if let timeStr = status.created_at where timeStr != ""{
            
            // 将服务器的时间格式化为NSDate
            
            let createDate = NSDate.createDate(timeStr, formaterStr: "EE MM dd HH:mm:ss Z yyyy")
            
            create_time = createDate.descriptionStr()
        }
        
        // 处理配图
        if let picurls = (status.retweeted_status?.pic_urls != nil) ? status.retweeted_status?.pic_urls : status.pic_urls {
            // 创建一个空的数组
            thumbnail_pic = [NSURL]()
            
            bmiddle_pic = [NSURL]()
            /**
            遍历配图数组下载图片
            */
            for dict in picurls {
                
                guard var urlStr = dict["thumbnail_pic"] as? String else {
                    
                    continue
                }
                let url = NSURL(string: urlStr)!
                // 将元素添加到数组中
                thumbnail_pic?.append(url)
                
                // 处理大图
                urlStr = urlStr.stringByReplacingOccurrencesOfString("thumbnail", withString: "large")
                bmiddle_pic?.append(NSURL(string: urlStr)!)
            }
            
           
            
        }
        
        
        
        // 转发
        if let text = status.retweeted_status?.text {
            
            let  name = status.retweeted_status?.user?.screen_name ?? ""
            forwardText = "@" + name + ": " + text
        }
        
    }
    
    /**认证图片*/
    var verifiedImage:UIImage?
    
    /**等级图片*/
    var mbrankImage:UIImage?
    
    /**格式化后的时间*/
    var create_time:String? = ""
    
    /**格式化后的来源*/
    var source_str:String?
    
    /**保存配图地址*/
    var thumbnail_pic:[NSURL]?
    
    /**大 图 */
    var bmiddle_pic:[NSURL]?
    
    /**转发微博的正文*/
    var forwardText:String?
}
