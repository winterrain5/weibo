//
//  QRCodeViewController.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/8/2.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var customTabbar: UITabBar!
    // 扫描结过
    @IBOutlet weak var customLabel: UILabel!
    @IBOutlet weak var scanLineView: UIImageView!
    // 冲击波顶部约束
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
   // 容器视图高度约束
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        customTabbar.selectedItem = customTabbar.items?.first
        
        customTabbar.delegate = self
        
        // 开始扫描二维码
        scanQRCode()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        startAnimation()
        
    }
    // 扫描二维码
    private func scanQRCode() {
        
        // 1、判断输入能否添加到会话中
        if !session.canAddInput(input) {
            return
        }
        // 2、判断输出能否添加到会话中
        if !session.canAddOutput(output) {
            return
        }
        // 3、添加输入输出到会话
        session.addInput(input)
        session.addOutput(output)
        // 4、设置输出能够解析的数据类型
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        // 5、设置监听输出到的数据
       
        output.setMetadataObjectsDelegate(self, queue:  dispatch_get_main_queue())
        
        // 添加预览图层
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        previewLayer.frame = view.bounds
        // 6、开始扫描
        session.startRunning()
    }
    // 开始动画
    private func startAnimation () {
        
        // 设置冲击波底部和容器顶部对齐
        scanLineCons.constant = -containerHeightCons.constant
        view.layoutIfNeeded()
        // 执行扫描动画
        // 一般在swift中不推荐写self
        // 但是在闭包和区分变量时需要加上self
        UIView.animateWithDuration(1.5) { () -> Void in
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.scanLineCons.constant = self.containerHeightCons.constant
            self.view.layoutIfNeeded()
        }

    }
    
    
    
    @IBAction func backBtnClick(sender: UIBarButtonItem) {
        
         dismissViewControllerAnimated(true , completion: nil)
    }
    @IBAction func photoBtnClick(sender: UIBarButtonItem) {
        
        
    }
    
    // MARK: - 懒加载
    // 输入对象
    private lazy var input:AVCaptureDeviceInput = {
       
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        return try! AVCaptureDeviceInput(device: device)
        
    }()
    // 会话
    private lazy var session: AVCaptureSession = AVCaptureSession()
    
    // 输出对象
    private lazy var output:AVCaptureMetadataOutput =  AVCaptureMetadataOutput()
    
    // 预览图层
    private lazy var previewLayer:AVCaptureVideoPreviewLayer =  AVCaptureVideoPreviewLayer(session: self.session)
        
    
}

extension QRCodeViewController:UITabBarDelegate {
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        self.containerHeightCons.constant = (item.tag == 1) ? 100 : 250;
        view.layoutIfNeeded()
        
        // 移除所有动画
        scanLineView.layer.removeAllAnimations()
        
        // 重新开启动画
        
        startAnimation()
        
        
    }
}
extension QRCodeViewController:AVCaptureMetadataOutputObjectsDelegate {
    
    //只要扫描到结果就会调用
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        customLabel.text = metadataObjects.last?.stringValue
    }
}