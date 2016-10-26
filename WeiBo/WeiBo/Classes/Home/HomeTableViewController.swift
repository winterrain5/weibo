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
    var statusesListModel:StatusListModel = StatusListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // 设置导航条
        createNav()
        
        // 注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("titleChange"), name: CSPresentationManagerDidPresenter, object: animatorManager)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("titleChange"), name: CSPresentationManagerDidDismiss, object: animatorManager)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("showBrowser:"), name: CSShowPhotoBrowserController, object: nil)

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
            
            refreshControl = CSRefreshController()
            refreshControl?.addTarget(self, action: Selector("loadStatusesData"), forControlEvents: UIControlEvents.ValueChanged)
            // 自动显示
 
        }
        
        
        navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)
        
        
    }
    
    deinit {
        
        // 移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    // MARK: -展示图片控制器
    @objc private func showBrowser(notice:NSNotification) {
        print(notice.userInfo)
        guard let pictures = notice.userInfo!["bmiddle"] as? [NSURL] else {
            
            SVProgressHUD.showWithStatus("没有图片")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
            dispatch_after(dispatch_time_t.init(1.2), dispatch_get_main_queue(), { () -> Void in
                SVProgressHUD.dismiss()
            })
            return
        }
        guard let index = notice.userInfo!["indexPath"] as? NSIndexPath else {
            SVProgressHUD.showWithStatus("没有索引")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
            dispatch_after(dispatch_time_t.init(1.2), dispatch_get_main_queue(), { () -> Void in
                SVProgressHUD.dismiss()
            })
            return
        }
        
        // 弹出图片浏览器
        let vc = CSPictureBrowserController(pics: pictures, indexpath: index)
        presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: 内部方法
    @objc private func loadStatusesData() {
       
            statusesListModel.loadStatusesData(lastStatusFlag) { (models, error) -> () in
                if error != nil {
                    SVProgressHUD.showErrorWithStatus("获取微博数据失败")
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
                    return
                }
                self.refreshControl?.endRefreshing()
                
                // 显示刷新提醒
                
                self.showRefreshStatus(models!.count)
                
                self.tableView.reloadData()
        }
        
    }
    
    private func showRefreshStatus(count:Int) {
        
        // 设置提醒文本
        
        tipLabel.hidden = false

        
        tipLabel.text = (count == 0) ? "没有更多数据" : "刷新到\(count)条数据"
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            
            self.tipLabel.transform = CGAffineTransformMakeTranslation(0, 44)
            
            }) { (_) -> Void in
                UIView.animateWithDuration(1.0, delay: 2.0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                        self.tipLabel.transform = CGAffineTransformIdentity
                    }, completion: { (_) -> Void in
                        self.tipLabel.hidden = true
                })
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
    
    private var tipLabel:UILabel = {
        
        let lb = UILabel()
        lb.frame = CGRect(x: 10, y: 0, width: UIScreen.mainScreen().bounds.width - 20, height: 44)
        lb.text = "没有更多的数据"
        lb.textColor = UIColor.whiteColor()
        lb.textAlignment = NSTextAlignment.Center
        lb.backgroundColor = UIColor.orangeColor()
        lb.layer.cornerRadius = 5
        lb.layer.masksToBounds = true
        lb.hidden = true
        return lb
        
    }()
    
    // 最后一条微博的标记
    private var lastStatusFlag:Bool?
}

// MARK: - UIViewControllerTransitioningDelegate 实现代理
extension HomeTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 如果self.statuses.count 为空 则传0
        return self.statusesListModel.statusesViewModel?.count ?? 0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let  viewModel = statusesListModel.statusesViewModel![indexPath.row]
        let rid = (viewModel.status.retweeted_status != nil ) ? "forwardCell" : "homeCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(rid) as! HomeTableViewCell
        cell.statusViewModel = viewModel
        
        // 判断是否是最后一条数据
        if indexPath.row == (statusesListModel.statusesViewModel!.count - 1){
            
            lastStatusFlag = true
             loadStatusesData()
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
         let  viewModel = statusesListModel.statusesViewModel![indexPath.row]
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
