//
//  User.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/9/6.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

class User: NSObject {
    /**id*/
    var idstr:String?
    /**用户昵称*/
    var screen_name:String?
    /**头像地址*/
    var profile_image_url:String?
    /**认证类型*/ // -1 :没有认证 0：认证用户 2、3、5：企业认证 220 达人
    var verified_type:Int = -1

    /**用户等级*/
    var mbrank:Int = -1

    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    // 如果不能一一对应 重写该方法即可
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        let property = ["screen_name","idstr","profile_image_url","verified_type","mbrank"]
        let dict = dictionaryWithValuesForKeys(property)
        return "\(dict)"
    }
}
