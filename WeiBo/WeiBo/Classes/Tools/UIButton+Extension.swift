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
    
    convenience init(imageName: String?,backgroundImageName: String?) {
        self.init()
        
        if let name = imageName {
            
            setImage(UIImage(named:name), forState: UIControlState.Normal)
            setImage(UIImage(named: name + "_highlighted"), forState: UIControlState.Highlighted)
        }
        
       
        if let  backgroundName = backgroundImageName {
            setBackgroundImage(UIImage(named: backgroundName), forState: UIControlState.Normal)
            setBackgroundImage(UIImage(named: backgroundName + "_highlighted"), forState: UIControlState.Highlighted)
            
        }
       
        sizeToFit()
    }
}
