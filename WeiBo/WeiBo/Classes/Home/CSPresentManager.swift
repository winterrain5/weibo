//
//  CSPresentManager.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/8/1.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

// 通知名
let CSPresentationManagerDidPresenter = "CSPresentationManagerDidPresenter"

let CSPresentationManagerDidDismiss = "CSPresentationManagerDidDismiss"


class CSPresentManager: NSObject,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning {
    // 当前是否是展现popOver
    private var isPresent = false
    
    var presentFrame = CGRectZero
    
    /**
     返回一个负责转场动画的对象     */
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        let pc = CSPresentationController(presentedViewController: presented, presentingViewController: presenting)
        
        pc.presentFrame = presentFrame
        
        return pc
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        
        // 发送通知
        NSNotificationCenter.defaultCenter().postNotificationName(CSPresentationManagerDidPresenter, object: self)
        
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        NSNotificationCenter.defaultCenter().postNotificationName(CSPresentationManagerDidDismiss, object: self)
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return 998
    }
    
    // 管理modal如何展现和消失
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresent {
            
            willPresentedViewController(transitionContext)
            
        } else {
            
            willDismissViewController(transitionContext)
        }
        
    }
    
    // 展现动画
    private func willPresentedViewController (transitionContext: UIViewControllerContextTransitioning) {
        // 获取需要弹出的视图
        
        guard  let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else {
            return
        }
        
        
        // 将需要弹出的视图添加到containView
        transitionContext.containerView()?.addSubview(toView)
        
        // 执行动画
        toView.transform = CGAffineTransformMakeScale(1.0, 0.0)
        
        // 修改layer的锚点位置
        toView.layer.anchorPoint = CGPointMake(0.5, 0.0)
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            toView.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                transitionContext.completeTransition(true)
        }
        

    }
    
    // 消失
    private func willDismissViewController (transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) else {
            
            return
        }
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            fromView.transform = CGAffineTransformMakeScale(1.0, 0.0)
            }, completion: { (_) -> Void in
                
                transitionContext.completeTransition(true)
                
        })

    }
}
