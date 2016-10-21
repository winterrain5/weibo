//
//  HomeTableViewController.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/7/26.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
class HomeTableViewController: BaseTableViewController {

    
    var homeCell:HomeTableViewCell?
    // 所有微博数据
    var statusesViewModel:[StatuesViewModel]? {
        
        // 调用statuses 就会调用didset 方法
        didSet {
            
            tableView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // 设置导航条
        createNav()
        
        // 注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("titleChange"), name: CSPresentationManagerDidPresenter, object: animatorManager)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("titleChange"), name: CSPresentationManagerDidDismiss, object: animatorManager)
        

        // 判断用户是否登录
        if !isLoging {
            
            // 设置访客视图
            visitorView?.setupVisitorViewInfo(nil, title: "关注一些人，回这里看看有什么惊喜")
            
        } else {
            
            loadStatusesData()
            
            // 预估行高 可以减少计算次数 提高性能
            tableView.estimatedRowHeight = 400
            // 自动计算高
            //        tableView.rowHeight = UITableViewAutomaticDimension
            
            refreshControl = UIRefreshControl()
            refreshControl?.addTarget(self, action: Selector("loadMoreData"), forControlEvents: UIControlEvents.ValueChanged)

        }
        
                // 加载数据
        
    }
    
    private func loadMoreData() {
        
        refreshControl?.endRefreshing()
    }
    deinit {
        
        // 移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    
    // MARK: 内部方法
    private func loadStatusesData() {
        SVProgressHUD.showWithStatus("加载中...")
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        NetworkTool.shareInstance.loadStatuses { (array, error) -> () in
            if error != nil {
                
                SVProgressHUD.showWithStatus("获取数据失败")
                return
            }
            
            guard let arr = array else {
                
                return
            }
            SVProgressHUD.dismiss()
            var models = [StatuesViewModel]()
            for dict in arr {
                
                let status = Status(dict: dict)
                
                let statusViewModel = StatuesViewModel(status: status)
                models.append(statusViewModel)
            }
            
            // 缓存配图
            self.cachesImages(models)
        }
        
    }
    
    
    /**
    *  缓存配图
    */
    private func cachesImages(viewModels:[StatuesViewModel]) {
    
        // 创建一个组
        let group = dispatch_group_create()
        
        for viewModel in viewModels {
            
            // 取出url数组
            guard let picurls = viewModel.thumbnail_pic else {
                
                continue
            }
            
            // 遍历配图数组下载图片
            for url in picurls {
                
                // 将当前的下载操作添加到组中
                dispatch_group_enter(group)
                
                // sdwebimage下载图片
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (image, error, _, _,_) -> Void in
                
                    // 将当前下载操作从组中移除 只有当所有添加进去的操作都被移除了才会调用dispatch_group_notify
                    dispatch_group_leave(group)
                })
                
            }
        
            
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            
            self.statusesViewModel = viewModels
            print("全部下载完成")
        }
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
        
        let sb = UIStoryboard(name: "QRCode", bundle: nil)
        
        let vc = sb.instantiateInitialViewController()
        
        presentViewController(vc!, animated: true, completion: nil)
         print("pop")
    }
    
    private lazy var animatorManager:CSPresentManager =  {
       
        let manager = CSPresentManager()
        
        manager.presentFrame = CGRect(x: 100, y: 50, width: 200, height: 400)
        return manager;
        
    }()
    
    private lazy var titleButton:TitleButton = {
    
        let titleButton = TitleButton()
        let title = UserAccountModel.loadUserAccount()?.screen_name
        titleButton.setTitle(title, forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector("titleBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        return titleButton
        
    }()
    
    // 定义字典 缓存行高 提高性能
    private var rowHeightCaches = [String:CGFloat]()
}

// MARK: - UIViewControllerTransitioningDelegate 实现代理
extension HomeTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 如果self.statuses.count 为空 则传0
        return self.statusesViewModel?.count ?? 0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let  viewModel = statusesViewModel![indexPath.row]
        let rid = (viewModel.status.retweeted_status != nil ) ? "forwardCell" : "homeCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(rid) as! HomeTableViewCell
        cell.statusViewModel = viewModel
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
         let  viewModel = statusesViewModel![indexPath.row]
         let rid = (viewModel.status.retweeted_status != nil ) ? "forwardCell" : "homeCell"
        // 从缓存中获取行高
        guard let height = rowHeightCaches[viewModel.status.idstr ?? "-1"]  else {
            // 缓存中没有行高
            // 获取当前行对应的cell
            let cell = tableView.dequeueReusableCellWithIdentifier(rid) as! HomeTableViewCell
            
            // 缓存行高
            let temp = cell.cacluateRowHeight(viewModel)
            rowHeightCaches[viewModel.status.idstr ?? "-1"] = temp
            
            return temp
            
        }
        
        // 缓存中有就直接返回行高
        return height
    }
    override func didReceiveMemoryWarning() {
        
        // 释放缓存数据
        rowHeightCaches.removeAll()
    }
    
}
