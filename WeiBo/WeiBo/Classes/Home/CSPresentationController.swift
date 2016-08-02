//
//  CSPresentationController.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/7/31.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

class CSPresentationController: UIPresentationController {
    
   var presentFrame = CGRectZero
    
   override func containerViewDidLayoutSubviews() {
    
        presentedView()?.frame = presentFrame
    
    
        // 添加蒙版
    
        containerView?.insertSubview(coverButton, atIndex: 0)
        coverButton.frame = UIScreen.mainScreen().bounds
        coverButton.addTarget(self, action: Selector("coverButtonClick"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    @objc private func coverButtonClick() {
        
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
        print("adf")
    }
    
    // MARK: -懒加载
    private var coverButton:UIButton = {
       
        let btn = UIButton()
       
        return btn
        
    }()
   
}
