//
//  ComposeController.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/10/28.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeController: UIViewController {

    @IBOutlet weak var sendBtn: UIBarButtonItem!
    @IBOutlet weak var customTextView: CSTextView!
    @IBOutlet weak var customtitleView: CSTitleView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customTextView.placeHolder = "分享新鲜事..."
//        self.edgesForExtendedLayout = UIRectEdge.None
        sendBtn.enabled = false
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        customTextView.becomeFirstResponder()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        customTextView.resignFirstResponder()
    }
    @IBAction func closeBtnClick(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sendStatusBtnClick(sender: AnyObject) {
        
        let text = customTextView.text
        
        NetworkTool.shareInstance.sendStatus(text) { (objc, error) -> () in
            if error != nil  {
                SVProgressHUD.showErrorWithStatus("发送微博失败")
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
            } else {
                SVProgressHUD.showSuccessWithStatus("发送微博成功")
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
    }
}

extension ComposeController:UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        sendBtn.enabled = textView.hasText()
    }
}