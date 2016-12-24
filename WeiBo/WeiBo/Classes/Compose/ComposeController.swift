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
    /// 控制器容器高度约束
    @IBOutlet weak var statusContainViewConsH: NSLayoutConstraint!
/// 控制器容器view
    @IBOutlet weak var statusContainerView: UIView!
/// 最大输入字数
    let maxCount = 10
/// 提醒用户字数
    @IBOutlet weak var tipLabel: UILabel!
    // 工具条底部约束
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    @IBOutlet weak var sendBtn: UIBarButtonItem!
    // 发送文字的textView
    @IBOutlet weak var customTextView: CSTextView!
/// 标题
    @IBOutlet weak var customtitleView: CSTitleView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customTextView.placeHolder = "分享新鲜事..."
        sendBtn.enabled = false
        
        // 注册通知 监听键盘弹起
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillChange:"), name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        addChildViewController(emotionKeyboardVC)
        
        statusContainViewConsH.constant = 0
        customTextView.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 如果在这个地方召唤键盘 执行工具条的动画时 第一次显示会从边界穿出来
//        customTextView.becomeFirstResponder()
    }
    
    override func viewDidAppear(animated: Bool) {
         super.viewDidAppear(animated)
        

    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        customTextView.resignFirstResponder()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // 键盘监听事件
    func keyboardWillChange(notic: NSNotification) {
        // 获取键盘的frame
       let rect = notic.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        let  height = UIScreen.mainScreen().bounds.height
        let offSetY = height - rect.origin.y
        // 获取当前动画节奏 
        //如果是UIKeyboardAnimationCurveUserInfokey 连续执行两次动画会直接忽略上一次进入下一次
        // 而普通节奏会等待上一次做完才会执行下一次
        let curve = notic.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        
        self.toolBarBottomCons.constant = offSetY
        UIView.animateWithDuration(0.25) { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve.integerValue)!)
            self.view.layoutIfNeeded()
        }
        
    }
    
    // MARK:- 按钮监听事假
    @IBAction func closeBtnClick(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sendStatusBtnClick(sender: AnyObject) {
        
        let text = customTextView.emoticonStr()
        
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
    // 选择图片
    @IBAction func imageItemBtnClick(sender: UIBarButtonItem) {
        statusContainViewConsH.constant = UIScreen.mainScreen().bounds.height * 0.7
        UIView.animateWithDuration(0.4) { () -> Void in
            self.view.layoutIfNeeded()
        }
        customTextView.resignFirstResponder()
    }
    // 选择表情  
    @IBAction func emotionItemBtnClick(sender: UIBarButtonItem) {
        // 如果是系统默认的键盘 inputView = nil
        // 如果不是系统默认的键盘 inputView ！= nil
        // 注意点：要想切换键盘 必须先关闭键盘，切换之后再打开
        
        customTextView.resignFirstResponder()
        if customTextView.inputView != nil {
            // 切换为系统键盘
            customTextView.inputView = nil
        } else{
            // 切换为自定义键盘
            customTextView.inputView = emotionKeyboardVC.view
        }
        customTextView.becomeFirstResponder()
       
    }
    
    // 表情键盘控制器
    private lazy var emotionKeyboardVC: CSEmotionKeyboardController = CSEmotionKeyboardController {[unowned self] (emoticon) -> () in
     self.customTextView.insertEmoticon(emoticon)
    }
    
}

extension ComposeController:UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        sendBtn.enabled = textView.hasText()
        self.customTextView.placeHolderLable.hidden = textView.hasText()
        
        // 计算当前还可以输入多少内容
        let  currentCount = self.customTextView.emoticonStr().characters.count
        let  leftCount = maxCount - currentCount
        tipLabel.text =  "\(leftCount)"
        sendBtn.enabled = leftCount >= 0
        tipLabel.textColor = leftCount >= 0 ? UIColor.lightGrayColor() : UIColor.redColor()
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        customTextView.resignFirstResponder()
    }
}