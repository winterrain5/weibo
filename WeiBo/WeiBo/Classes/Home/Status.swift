//
//  Status.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/9/5.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

class Status: NSObject {

    // 微博创建时间
    var created_at:String?
    
    /**字符串行的微博id*/
    var idstr:String?
    
    /**微博内容*/
    var text:String?
    
    /**微博来源*/
    var  source:String?

    
    /**微博作者*/
    var user:User?

    
    init(dict: [String: AnyObject]) {
        
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    //kvc的 setValuesForKeysWithDictionary内部调用setValue方法
    override func setValue(value: AnyObject?, forKey key: String) {
        
        // 拦截user赋值操作
        if key == "user" {
            
            user = User(dict: value as! [String : AnyObject])
            return 
        }
        
        super.setValue(value, forKey: key)
    }
    
    // 如果不能一一对应 重写该方法即可
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
   override var description: String {
     let property = ["created_at","idstr","text","source"]
    let dict = dictionaryWithValuesForKeys(property)
    return "\(dict)"
    }
}
