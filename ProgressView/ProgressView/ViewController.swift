//
//  ViewController.swift
//  ProgressView
//
//  Created by 石冬冬 on 16/10/26.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
        view.addSubview(pv)
        pv.frame = CGRectMake(50, 50, 200, 200)
        pv.image = UIImage(named: "JPEG 图像-43A2AC8A5765-1")
//        pv.backgroundColor = UIColor.redColor()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("test"), userInfo: nil, repeats: true)
    }
    
    func test() {
        pv.progress += 0.1
    }
    
    private lazy var pv:CSProgressImageView = CSProgressImageView(frame: CGRectZero)
 


}

