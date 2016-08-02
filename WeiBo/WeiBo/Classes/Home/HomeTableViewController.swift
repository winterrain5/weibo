//
//  HomeTableViewController.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/7/26.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 判断用户是否登录
        if !isLoging {
            
            // 设置访客视图
            visitorView?.setupVisitorViewInfo(nil, title: "关注一些人，回这里看看有什么惊喜")
        }
        
        // 设置导航条
        createNav()
        
        // 注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("titleChange"), name: CSPresentationManagerDidPresenter, object: animatorManager)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("titleChange"), name: CSPresentationManagerDidDismiss, object: animatorManager)
    }
    
    deinit {
        
        // 移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    private func createNav () {
        
        // 添加导航条按钮
        
        navigationItem.leftBarButtonItem =  UIBarButtonItem(imageName:"navigationbar_friendsearch", hightLightName: "navigationbar_friendsearch_highlighted",target: self,action: Selector("friendsearch"))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName:"navigationbar_pop", hightLightName: "navigationbar_pop_highlighted",target: self,action: Selector("pop"))
        
        // 创建标题
        navigationItem.titleView = titleButton
    }
    
   @objc private func titleChange() {
        
        titleButton.selected = !titleButton.selected
    }
    
    // MARK:  -点击事件
    @objc private func titleBtnClick(btn: UIButton) {
        
        btn.selected = !btn.selected
        
        // 显示菜单
        
        let sb = UIStoryboard(name: "popover", bundle: nil)
        
        guard let menuView = sb.instantiateInitialViewController() else {
            
            return
        }
        // 自定义转场动画
        // 设置转场代理
        
        menuView.transitioningDelegate = animatorManager
        
        // 设置转场动画样式
        
        menuView.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(menuView, animated: true, completion: nil)
        print("titleBtnClick")
    }
    @objc private func friendsearch() {
        print("search")
    }
    @objc private func pop() {
         print("pop")
    }
    
    private lazy var animatorManager:CSPresentManager =  {
       
        let manager = CSPresentManager()
        
        manager.presentFrame = CGRect(x: 100, y: 50, width: 200, height: 400)
        return manager;
        
    }()
    
    private lazy var titleButton:TitleButton = {
    
        let titleButton = TitleButton()
        titleButton.setTitle("哈哈哈", forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector("titleBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        return titleButton
        
    }()
}

// MARK: - UIViewControllerTransitioningDelegate 实现代理

