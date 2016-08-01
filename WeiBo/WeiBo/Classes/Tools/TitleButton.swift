//
//  TitleButton.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/7/31.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

class TitleButton: UIButton {
    
    
   override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
        sizeToFit()
        setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
    
    }
    
    // 通过XIB/SB 创建时调用
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setTitle(title: String?, forState state: UIControlState) {
        
        // ?? "" 作用: 判断title值是否为空 ，为空执行？？后语句，否则不执行
        super.setTitle((title ?? "") + "  ", forState: state)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 调整文字和图片的位置 offsetInPlace：设置控件的偏移位 但是会被调用多次
//        titleLabel?.frame.offsetInPlace(dx:-imageView!.frame.width, dy: 0)
//        imageView?.frame.offsetInPlace(dx: titleLabel!.frame.width, dy: 0)
        titleLabel?.frame.origin.x = 0;
        imageView?.frame.origin.x = titleLabel!.frame.width
    }
}
