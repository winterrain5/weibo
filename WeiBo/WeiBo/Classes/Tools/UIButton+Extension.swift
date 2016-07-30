//
//  UIButton+Extension.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/7/28.
//  Copyright © 2016年 sdd. All rights reserved.
//

// 分类
import UIKit

extension UIButton {
    
    convenience init(imageName: String,backgroundImageName: String) {
        self.init()
        setImage(UIImage(named:imageName), forState: UIControlState.Normal)
        setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        
        setBackgroundImage(UIImage(named: backgroundImageName), forState: UIControlState.Normal)
        setBackgroundImage(UIImage(named: backgroundImageName + "_highlighted"), forState: UIControlState.Highlighted)
        sizeToFit()
    }
}
