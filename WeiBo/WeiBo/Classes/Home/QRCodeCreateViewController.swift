//
//  QRCodeCreateViewController.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/8/5.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

class QRCodeCreateViewController: UIViewController {

    @IBOutlet weak var customImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        // 还原滤镜默认属性
        filter?.setDefaults()
        // 设置需要生成的二维码的数据到滤镜中
        
        filter?.setValue("哈哈哈哈哈".dataUsingEncoding(NSUTF8StringEncoding), forKey: "InputMessage")
        guard let ciImage =  filter?.outputImage else {
            
            return;
        }
        customImageView.image = createNonInterpolaterUIimageForimCIImage(ciImage, size: 200)
    }
    /**
        生成高清无码二维码
     
     - parameter image: 需要生成二维码的原始图片
     
     - returns: 生成的图片
     */
    private func createNonInterpolaterUIimageForimCIImage(image:CIImage,size:CGFloat)->UIImage {
        let extent:CGRect = CGRectIntegral(image.extent)
        let scale:CGFloat = min(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent))
        
        // 创建bitmap
        let width = CGRectGetWidth(extent) * scale
        let height = CGRectGetHeight(extent) * scale
        let cs: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, cs, 0)!
        let context = CIContext(options: nil)
        let bitmapImage:CGImageRef = context.createCGImage(image, fromRect: extent)
        
        CGContextSetInterpolationQuality(bitmapRef, CGInterpolationQuality.None)
        CGContextScaleCTM(bitmapRef, scale, scale)
        CGContextDrawImage(bitmapRef, extent, bitmapImage)
        
        // 保存bitmap到图片
        let scaledImage:CGImageRef = CGBitmapContextCreateImage(bitmapRef)!
        
        return UIImage(CGImage: scaledImage)
    }

   }
