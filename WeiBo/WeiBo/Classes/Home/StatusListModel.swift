//
//  StatusListModel.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/10/21.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class StatusListModel: NSObject {
    
    var statusesViewModel:[StatuesViewModel]?
    
    @objc private func loadStatusesData(lastStatusFlag:Bool,finish:(models:[StatuesViewModel]?,error:NSError?)->()) {
        
        SVProgressHUD.showWithStatus("加载中...")
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        
        var  since_id = statusesViewModel?.first?.status.idstr ?? "0"
        var max_id = "0"
        if lastStatusFlag == true  {
            
            since_id = "0"
            max_id = statusesViewModel?.last?.status.idstr ?? "0"
            
        }
        
        
        
        NetworkTool.shareInstance.loadStatuses(since_id,max_id:max_id) { (array, error) -> () in
            if error != nil {
                
//                SVProgressHUD.showWithStatus("获取数据失败")
                finish(models: nil
                    , error: error)
                return
            }
            
            guard let arr = array else {
                
                return
            }
//            SVProgressHUD.dismiss()
            var models = [StatuesViewModel]()
            for dict in arr {
                
                let status = Status(dict: dict)
                
                let statusViewModel = StatuesViewModel(status: status)
                models.append(statusViewModel)
            }
            
            if since_id != "0" {
                
                self.statusesViewModel = models + self.statusesViewModel!
                
            } else if max_id != "0"{
                self.statusesViewModel = self.statusesViewModel! + models
            } else {
                
                self.statusesViewModel = models
            }
            
            // 缓存配图
            self.cachesImages(models,finish: finish)
            
            
            
            
        }
        
    }
    
    /**
     *  缓存配图
     */
    private func cachesImages(viewModels:[StatuesViewModel],finish:(models:[StatuesViewModel]?,error:NSError?)->()) {
        
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
            
            //            self.statusesViewModel = viewModels
            print("全部下载完成")
            finish(models: viewModels, error: nil)
        }
    }

}
