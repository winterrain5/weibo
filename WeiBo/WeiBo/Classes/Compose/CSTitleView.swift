//
//  CSTitleView.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/10/28.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit
import SnapKit
class CSTitleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

  
    private func setupUI() {
        
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        subTitleLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.top.equalTo(titleLabel.snp_bottom)
        }
        
    }
    
    
    private lazy var titleLabel: UILabel = {
       
        let lb = UILabel()
        lb.textColor = UIColor.darkTextColor()
        lb.text = "发送微博"
        lb.font = UIFont.systemFontOfSize(18)
        return lb
        
    }()
    
    private lazy var subTitleLabel: UILabel = {
        
        let lb = UILabel()
        lb.textColor = UIColor.darkGrayColor()
        lb.text = "那我就是御狐神"
        lb.font = UIFont.systemFontOfSize(14)
        return lb
        
    }()
    
}
