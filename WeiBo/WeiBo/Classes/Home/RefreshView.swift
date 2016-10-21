//
//  RefreshView.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/10/21.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit
import SnapKit
class CSRefreshController: UIRefreshControl {
    override init() {
         super.init()
        addSubview(refreshView)
        refreshView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self)
            make.size.equalTo(CGSizeMake(110, 30))
        }
        
        // 监听RefreshController的frame改变
        
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
    }

    deinit {
        removeObserver(self, forKeyPath: "frame")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 记录是否让箭头旋转
    var rotationFlag = false
    var loadingFlag = false
    // MARK: -内部方法
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if frame.origin.y == 0 || frame.origin.y == -64 {
            
            return
        }
        
        // 是否触发下拉刷新事件
        if refreshing && !loadingFlag{
            loadingFlag = true
            // 隐藏箭头视图
            refreshView.startLoadingView()
            return
            
        }
        
        if frame.origin.y  > -30 && rotationFlag{
            rotationFlag = false
            refreshView.rotationView(rotationFlag)
        }
        
        if frame.origin.y < -30 && !rotationFlag {
            rotationFlag = true
            refreshView.rotationView(rotationFlag)
        }
        
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        loadingFlag = false
        refreshView.stopLoadingView()
        
    }
    
    //MARK: -懒加载
    private lazy var refreshView:RefreshView = RefreshView.refreshView()
}

class RefreshView: UIView {
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var topView: UIView!
    
    
    // 对外的初始化方法
    class func refreshView() -> RefreshView {
        return NSBundle.mainBundle().loadNibNamed("RefreshView", owner: nil, options: nil).last as! RefreshView
    }
    
    // 旋转箭头
    func rotationView(flag:Bool) {
        var angle:CGFloat = flag ? -0.01 : 0.01
        angle += CGFloat(M_PI)
        UIView.animateWithDuration(1.0) { () -> Void in
            self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform, angle)
        }
        
    }
    
    func startLoadingView() {
        
        topView.hidden = true
        // 创建动画
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        // 设置动画属性
        
        animation.toValue = 2 * M_PI
        animation.duration = 0.5
        animation.repeatCount = MAXFLOAT
        
        
        // 动画添加到图层
        loadingImageView.layer.addAnimation(animation, forKey: nil)
    }
    
    func stopLoadingView() {
        
        topView.hidden = false
        
        loadingImageView.layer.removeAllAnimations()
    }
}
