//
//  ComposeController.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/10/28.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

class ComposeController: UIViewController {

    @IBOutlet weak var customTextView: CSTextView!
    @IBOutlet weak var customtitleView: CSTitleView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customTextView.placeHolder = "分享新鲜事..."
//        self.edgesForExtendedLayout = UIRectEdge.None
        

    }

    @IBAction func closeBtnClick(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sendStatusBtnClick(sender: AnyObject) {
        
        
        
    }
}
