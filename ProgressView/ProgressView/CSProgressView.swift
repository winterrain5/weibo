//
//  CSProgressView.swift
//  ProgressView
//
//  Created by 石冬冬 on 16/10/26.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

class CSProgressView: UIView {

    // 记录当前进度 0.0~1.0
    var progress:CGFloat = 0.0 {
        didSet {
            // 调用这个方法系统就会调用 drawRect
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        // 画圆
        /*
        圆心：{宽度 * 0.5, 高度 * 0.5}
        半径：min(宽度，长度)
        开始位置：
        结束位置：
        */
        
        // 判断是否需要继续绘制
        if progress >= 1.0 {
            
            return
        }
        
        let height = rect.height * 0.5
        let width = rect.width * 0.5
        let center = CGPointMake(width, height)
        let radius = min(height, width)
        let start = -CGFloat(M_PI_2)
        let end = 2 * CGFloat(M_PI) * progress + start
        // 设置路径
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        path.addLineToPoint(center)
        path.closePath()
        UIColor.whiteColor().setFill()
        // 绘制图形
        path.fill()
    }
}
