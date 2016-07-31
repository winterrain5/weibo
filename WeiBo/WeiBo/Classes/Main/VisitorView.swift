//
//  VisitorView.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/7/30.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit
/*
protocol VisitorViewDelegate: NSObjectProtocol
{
    
    // 默认情况下协议中的方法都是必须实现的
    func visitorViewDidClickLoginBtn(visitor:VisitorView)
    func visitorViewDidClickRegisterBtn(visitor:VisitorView)
}
*/
class VisitorView: UIView {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var regiterButton: UIButton!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var rotationView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    // func == OC:-
    // class func == OC:+
    
    // 代理属性 ？:可为空
//    weak var delegate: VisitorViewDelegate?
    
    // 设置访客视图
    func setupVisitorViewInfo(imageName:String? ,title:String) {
       
        hintLabel.text = title
  
        guard let name = imageName else {
            // 没有设置图标 为首页
            
            startAnimation()
            
            return
        }
        rotationView.hidden = true
        iconView.image = UIImage(named:name)
    }
    
    private func startAnimation() {
        
        // 创建动画
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        // 设置动画属性
        
        animation.toValue = 2 * M_PI
        animation.duration = 5.0
        animation.repeatCount = MAXFLOAT
        
        // 默认情况下 只要视图消失 动画就会被移除
        animation.removedOnCompletion = false
        
        // 动画添加到图层
        rotationView.layer.addAnimation(animation, forKey: nil)
    }
    
    class func visitorView() -> VisitorView {
        return NSBundle.mainBundle().loadNibNamed("VisitorView", owner: nil, options: nil).last as! VisitorView
    }
    /*
    @IBAction func registerBtnClicked(sender: UIButton) {
        delegate?.visitorViewDidClickRegisterBtn(self)
        
    }
    
    @IBAction func loginBtnClicked(sender: UIButton) {
        delegate?.visitorViewDidClickLoginBtn(self)
        
    }
*/
}
