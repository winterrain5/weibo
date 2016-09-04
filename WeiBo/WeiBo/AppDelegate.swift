//
//  AppDelegate.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/7/25.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

       UITabBar.appearance().tintColor = UIColor.orangeColor()
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = defaultViewController()
        window?.makeKeyAndVisible()
        return true
    }


/*
    泛型函数：
    func  函数名称<T>(形参列表) -> 返回值类型 {
    }
    
    T 具体是什么类型由调用者告知
    
*/
    func CSLog<T>(message: T,fileName :String = __FILE__,methodName: String = __FUNCTION__, lineNumber: Int = __LINE__) {
    
        #if DEBUG
        print("\(methodName)[\(lineNumber)]\(message)");
        #endif
    }


}
extension AppDelegate
{
    
    /**
     设置默认界面
     
     - returns:
     */
    private func defaultViewController() ->UIViewController {
        
        // 判断是否登录
        if UserAccountModel.isLogin() {
            
            // 是否有新版本
            if isNewVeison() {
                
                let vc = UIStoryboard(name: "Newfeature", bundle: nil).instantiateInitialViewController()!
                return vc
            } else {
                
                let vc = UIStoryboard(name: "Wellcom", bundle: nil).instantiateInitialViewController()!
                return vc
            }
        }
        let sb = UIStoryboard(name: "Main", bundle: nil)
        return sb.instantiateInitialViewController()!
    }
    
    private func isNewVeison() -> Bool {
        
        let  currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        // 以前的版本号
        let defaults = NSUserDefaults.standardUserDefaults()
        let sanboxVersion = (defaults.objectForKey("currentVersion") as? String) ?? "0.0"
        if currentVersion.compare(sanboxVersion) == NSComparisonResult.OrderedDescending {
            
            
            // 将新版本存储为本地版本以便于下一次版本升级比较
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(currentVersion, forKey: "currentVersion")
            defaults.synchronize() // ios7之前需要些 之后可以不写
            return true
            
        } else {
            
            return false
        }
    }
}
