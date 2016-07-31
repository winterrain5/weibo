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

//        window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        window?.backgroundColor = UIColor.whiteColor()
//        window?.rootViewController = MainViewController()
//        window?.makeKeyAndVisible()
       
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

