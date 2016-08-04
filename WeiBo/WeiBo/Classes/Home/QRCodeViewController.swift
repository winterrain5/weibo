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
        
        view.layer.addSublayer(containerLayer)
        containerLayer.frame = view.bounds
        
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
    
    // MARK: -打开相册
    @IBAction func photoBtnClick(sender: UIBarButtonItem) {
        
        // 判断是否能够打开相册
        
        /*
        case PhotoLibrary
        case Camera
        case SavedPhotosAlbum
        */
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            return
        }
        
        // 创建相册
        let imagePickController = UIImagePickerController()
        
        imagePickController.delegate = self
        
        presentViewController(imagePickController, animated: true, completion: nil)
    }
    
    // MARK: -懒加载
    // 输入对象
    private lazy var input:AVCaptureDeviceInput = {
       
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        return try! AVCaptureDeviceInput(device: device)
        
    }()
    // 会话
    private lazy var session: AVCaptureSession = AVCaptureSession()
    
    // 输出对象
    private lazy var output:AVCaptureMetadataOutput =  {
       
        let out = AVCaptureMetadataOutput()
        
        
        // 获取屏幕的frame
        let viewRect = self.view.frame
        
        // 扫描容器的frame 
        let containViewRect = self.containerView.frame
        var x:CGFloat = 0
        var y:CGFloat = 0
        var height:CGFloat = 0
        var width:CGFloat = 0
        x = containViewRect.origin.y / viewRect.origin.x
        y = containViewRect.origin.x / viewRect.origin.y
        height = containViewRect.width / viewRect.width
        width = containViewRect.height / viewRect.height
//        let y =
//        let height = ;
//        let width = ;
        
        // 设置输出对象解析数据的范围
        // 参照是横屏的左上角
        out.rectOfInterest =  CGRect(x: x, y: y, width: width, height: height)
        
        return out
    }()
    
    // 预览图层
    private lazy var previewLayer:AVCaptureVideoPreviewLayer =  AVCaptureVideoPreviewLayer(session: self.session)
    
    // 描边图层
    private lazy var containerLayer:CALayer = CALayer()
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
        
        clearLayers()
        // 获取二维码的坐标 
        
        // corners { 148.0,11.6 151.2,58.4 192.1,56.7 190.4,9.4 }
        
        guard let metaData = metadataObjects.last as? AVMetadataObject else {
            return
        }
        
        let  objc = previewLayer.transformedMetadataObjectForMetadataObject(metaData)
   
        // 对扫描的二维码进行描边
        drawLines(objc as! AVMetadataMachineReadableCodeObject)
    }
    
    private func drawLines(objc: AVMetadataMachineReadableCodeObject) {
        
        clearLayers()
        
        // 安全校验
        guard let array = objc.corners else {
            
            return
        }
        
        
        // 创建图层 用于保存绘制的矩形
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.strokeColor = UIColor.orangeColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        
        // 创建UIBezierPath 绘制矩形
        let path  = UIBezierPath()
        var point = CGPointZero
        var index = 0
        CGPointMakeWithDictionaryRepresentation(array[index++] as! CFDictionary, &point)
       path.moveToPoint(point)
        // 将起点移动到其它点
        while index < array.count {
            CGPointMakeWithDictionaryRepresentation(array[index++] as! CFDictionary, &point)
            
            // 连接其它线
            path.addLineToPoint(point)
        }
       
        // 关闭路径
        path.closePath()
        
        layer.path = path.CGPath
        
        // 将图层添加到界面
        containerLayer.addSublayer(layer)
    }
    
    // 清空描边
    private func clearLayers() {
        
        guard let sublayers = containerLayer.sublayers else {
            
            return
        }
        for layer in sublayers
        {
             layer.removeFromSuperlayer()
        }
        
    }
}
extension QRCodeViewController:UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //实现该方法 选择不会自动关闭相册
        
        // 取出选中的图片
       guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            
            return
        }
        let ciImage = CIImage(image: image)!
        
        // 从选中的图片中读取二维码
        
        // 创建一个探测器
       let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil , options: [CIDetectorAccuracy:CIDetectorAccuracyLow])
        
        // 探测数据
       let results = detector.featuresInImage(ciImage)
        
        // 取出数据
        for result in results {
            
            print((result as! CIQRCodeFeature).messageString)
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
   
}