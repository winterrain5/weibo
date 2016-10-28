//
//  CSBrowserPresentationController.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/10/28.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit
protocol CSBrowserPresetationDelegate:NSObjectProtocol
{
    // 用于创建一个和点击图片一模一样的UIImageView
    func browserPresentationWillShowImageView(browserPresentationVC: CSBrowserPresentationController,indexPath:NSIndexPath)  -> UIImageView
    // 用于获取点击图片相对于window的frame
    func browserPresentationWillShowFromFrame (browserPresentationVC: CSBrowserPresentationController,indexPath:NSIndexPath)  -> CGRect
    // 用于获取点击图片最终的frame
    func browserPresentationWillShowToFrame (browserPresentationVC: CSBrowserPresentationController,indexPath:NSIndexPath)  -> CGRect
}

class CSBrowserPresentationController: UIPresentationController,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning {

    // 当前是否是展现popOver
    private var isPresent = false
    // 当前点击图片的索引
    private var index:NSIndexPath?
    
    weak var browserDelegate: CSBrowserPresetationDelegate?
    
    func setDefailtInfo(index: NSIndexPath, delegate:CSBrowserPresetationDelegate) {
        self.index = index
        self.browserDelegate = delegate
    }
    
    // MARK: -UIViewControllerTransitioningDelegate
    /**
    返回一个负责转场动画的对象     */
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        return CSBrowserPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
     
        
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
       
        return self
    }
    // MARK: -UIViewControllerAnimatedTransitioning
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return 0.5
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
        assert(index != nil, "必须设置被点击的cell的indexPath")
        
        // 获取需要弹出的视图
        // 获取需要弹出的视图
        
        guard  let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else {
            return
        }
        
        // 新建一个UIimageView 并且显示的内容和被点击的图片一样
        let imageView = browserDelegate?.browserPresentationWillShowImageView(self, indexPath:self.index!)

        // 获取点击图片相对于window的frame
        imageView!.frame = browserDelegate!.browserPresentationWillShowFromFrame(self, indexPath: index!)
        
        // 将需要弹出的视图添加到containView
        transitionContext.containerView()?.addSubview(imageView!)
        
        // 获取图片点击图片最终显示的尺寸
        let toFrame = browserDelegate?.browserPresentationWillShowToFrame(self, indexPath: index!)
        
        // 执行动画
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            
                imageView?.frame = toFrame!
            
            }) { (_) -> Void in
                
                imageView?.removeFromSuperview()
                transitionContext.containerView()?.addSubview(toView)
                // 告诉系统动画执行完毕
                transitionContext.completeTransition(true)
        }
        
//        toView.addSubview(imageView!)
        

    }
    
    // 消失
    private func willDismissViewController (transitionContext: UIViewControllerContextTransitioning) {
        
        transitionContext.completeTransition(true)
        
    }
}
