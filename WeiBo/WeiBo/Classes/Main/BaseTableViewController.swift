//
//  BaseTableViewController.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/7/30.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    // 记录用户登录状态
    var isLoging = true
    
    // 声明一个可选变量
    var visitorView: VisitorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 判断用户是否登录 否显示访客页面
        
    }
    
    override func loadView() {
        isLoging ? super.loadView() : setupVisitorView()
    }
    
    private func setupVisitorView () {
        visitorView = VisitorView.visitorView()
        
        view = visitorView
        
        visitorView?.regiterButton.addTarget(self, action: Selector("registerBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        visitorView?.loginButton.addTarget(self, action: Selector("loginBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        // 设置代理
//        visitorView?.delegate = self
    }
    @objc private func registerBtnClick(btn: UIButton) {
    
        print("注册")
    }
    
    @objc private func loginBtnClick(btn: UIButton) {
        
        let sb = UIStoryboard(name: "OAuth", bundle: nil)
        
        let vc = sb.instantiateInitialViewController()!
        
        presentViewController(vc, animated:true, completion: nil)
        
    }
}


/*
// 采用分类实现协议
extension BaseTableViewController:VisitorViewDelegate
{
    func visitorViewDidClickLoginBtn(visitor:VisitorView) {
        print("登录")
    }
    func visitorViewDidClickRegisterBtn(visitor:VisitorView) {
        print("注册")
    }
}
*/
