//
//  CSProgressImageView.swift
//  ProgressView
//
//  Created by 石冬冬 on 16/10/26.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

class CSProgressImageView: UIImageView {

    // 记录当前进度 0.0~1.0
    var progress:CGFloat = 0.0 {
        didSet {
            
            // 调用这个方法系统就会调用 drawRect
            progressView.progress = progress
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(progressView)
        progressView.backgroundColor = UIColor.clearColor()
    }
    
    override func layoutSubviews() {
        progressView.frame = self.bounds
    }
    
    private lazy var progressView: CSProgressView = CSProgressView()

}
