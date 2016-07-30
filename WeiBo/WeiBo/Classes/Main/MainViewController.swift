//
//  MainViewController.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/7/26.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

       addChildViewControllers()
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        tabBar.addSubview(composeButton)
        
        let rect = composeButton.frame
        let width = tabBar.bounds.width / CGFloat(childViewControllers.count)
        composeButton.frame = CGRect(x: 2 * width, y: 0, width: width, height: rect.height)
    }
    
    /*
        private  :私有权限 只能在当前文件访问
        internal :默认权限 可以在当前的framework中任意访问
        public   :最大权限 可以在当前farmerwork 及其它framework
    
        以上权限可以修饰方法、属性、类
    */
    // MARK: -按钮点击事件
    func composeButtonClick(btn: UIButton) {
        print("asdfasd")
    }
    /**
     添加所有自控制器
     */
    func addChildViewControllers() {
        addChildViewController("HomeTableViewController", title: "首页", imageName: "tabbar_home")
        addChildViewController("MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
        addChildViewController("DiscoverTableViewController", title: "", imageName: "")
        addChildViewController("DiscoverTableViewController", title: "发现", imageName: "tabbar_discover")
        addChildViewController("ProfileTableViewController", title: "我的", imageName: "tabbar_profile")
        
        tabBar.tintColor = UIColor.orangeColor()
    }
    
    // swift 支持方法重载
    func addChildViewController(childControllerName: String,title: String, imageName: String) {
        
        // 动态获取命名空间
        // guard 条件为假执行 避免{}嵌套
        guard let name = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as? String else {
            return
        }
        
        // 根据字符串 创建class
        let cls:AnyObject? = NSClassFromString(name + "." + childControllerName)
        
        // 根据class创建对象
        // swift中如果通过一个class 创建对象，必须告诉系统这个class的确切类型
        guard let typeCls = cls as? UITableViewController.Type else {
            return
        }
        
        let childController = typeCls.init()
        
        childController.title = title
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: imageName + "_selected")
        let nav = UINavigationController(rootViewController: childController)
        addChildViewController(nav)
    }
    
    // MARK: - 懒加载
    lazy var composeButton: UIButton = { // 闭包
       () -> UIButton
        in
        let btn = UIButton(imageName: "tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
       
        // 监听事件
        
        btn.addTarget(self, action:Selector("composeButtonClick:"), forControlEvents:UIControlEvents.TouchUpInside)
        
        
       
        return btn
    }()
    
}
