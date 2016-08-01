//
//  Extension.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/7/31.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

extension  UIBarButtonItem {
    convenience init(imageName: String,hightLightName:String,target: AnyObject?, action: Selector){
    let barButtonItem = UIButton()
    barButtonItem.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
    barButtonItem.setImage(UIImage(named: hightLightName), forState: UIControlState.Highlighted)
   barButtonItem.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
    barButtonItem.sizeToFit()
   self.init(customView:barButtonItem)
    }

}
