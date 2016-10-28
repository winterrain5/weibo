//
//  CSTextView.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/10/28.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

class CSTextView: UITextView {
    
    var placeHolder:NSString? {
        didSet {
            placeHolderLable.text = "分享新鲜事..."
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame,textContainer:textContainer)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    private func setupUI() {
        addSubview(placeHolderLable)
        placeHolderLable.frame = CGRectMake(4, 6, 100, 20)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("textChange"), name: UITextViewTextDidChangeNotification, object: nil)
    }
    
    @objc func textChange() {
        
        placeHolderLable.hidden = hasText()
    }
    
    private lazy var placeHolderLable: UILabel = {
       
        let lb = UILabel()
        lb.textColor = UIColor.lightGrayColor()
        lb.font = UIFont.systemFontOfSize(15)
        
        
        return lb
        
    }()

}
