//
//  CSPresentationController.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/7/31.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

class CSPresentationController: UIPresentationController {
   override func containerViewDidLayoutSubviews() {
    
        presentedView()?.frame = CGRectMake(100, 45, 200, 300)
    
    }
    
   
}
