//
//  UserAccountModel.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/8/7.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

class UserAccountModel: NSObject,NSCoding{
    var access_token:String?
    var expires_in:Int = 0
        {
        didSet{
            // 生成正在过期时间
            expires_date = NSDate(timeIntervalSinceNow: NSTimeInterval(expires_in))
        }
    }
    // 真正过期时间
    var  expires_date:NSDate?
    var uid:String?
    
    // 用户头像
    var  avatar_large:String?
    // 昵称
    var screen_name:String?
    
    init(dict:[String:AnyObject])
    {
        super.init()
        self.setValuesForKeysWithDictionary(dict)
        
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
   override var description: String {
        
        return "abc"
    }
    
    // 
    static var userAccount:UserAccountModel?
    
    class func loadUserAccount() ->UserAccountModel?  {
        // 判断是否加载过
        if userAccount != nil
        {
            // 直接返回
            return userAccount
        }
        
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        let filePath = (path as NSString).stringByAppendingPathComponent("userAccount.plist")
        //解归档对象
        guard let account =  NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? UserAccountModel else {
            
            print("还未授权")
            return nil
        }
        
//        // 校验是否过期
//        guard let date = userAccount?.expires_date else {
//            
//            return nil
//        }
//        if date.compare(NSDate()) != NSComparisonResult.OrderedAscending {
//            
//            return nil
//        }
        userAccount = account
        return userAccount
    

    }
    
    //判断用户是否登录
    class func isLogin() -> Bool {
        return UserAccountModel.loadUserAccount() != nil
    }
    
    
    // 获取用户信息
    
    func loadUserInfo(finished:(account:UserAccountModel?,error:NSError?)->()) {
    
        // 断言
        assert(access_token != nil
            , "使用该方法必须授权")
        let url = "/2/users/show.json"
        
        let parameters = ["access_token":access_token!,"uid":uid!]
    
    NetworkTool.shareInstance.GET(url, parameters: parameters, success: { (task, objc) -> Void in
        
            let dict = objc as! [String: AnyObject]
            self.avatar_large = dict["avatar_large"] as? String
            self.screen_name = dict["screen_name"] as? String
            finished(account: self, error: nil)
        
        }) { (task, error) -> Void in
            finished(account: nil, error: error)

            print(error)
    }
    }
    
    func saveAccount() -> Bool
    {
       
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        let filePath = (path as NSString).stringByAppendingPathComponent("userAccount.plist")
       return NSKeyedArchiver.archiveRootObject(self, toFile: filePath)
        
    }
    
    
    // MARK: -NScoding
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeInteger(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_date, forKey: "expires_date")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
    }
    required  init?(coder aDecoder: NSCoder) {
        
        self.access_token = aDecoder.decodeObjectForKey("access_token") as? String
        self.expires_in = (aDecoder.decodeIntegerForKey("expires_in") as? Int)!
        self.uid = aDecoder.decodeObjectForKey("uid") as? String
        self.expires_date = aDecoder.decodeObjectForKey("expires_date") as? NSDate
        
        self.avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        self.screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
    }

}

