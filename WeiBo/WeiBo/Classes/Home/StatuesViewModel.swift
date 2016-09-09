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
    }
    
    /**认证图片*/
    var verifiedImage:UIImage?
    
    /**等级图片*/
    var mbrankImage:UIImage?
    
    /**格式化后的时间*/
    var create_time:String? = ""
    
    /**格式化后的来源*/
    var source_str:String?
}