//
//  WellcomViewController.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/8/30.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit
import SDWebImage
class WellcomViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iocnImageView: UIImageView!
    @IBOutlet weak var iconBootomCons: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.iocnImageView.layer.cornerRadius = 45
        iocnImageView.layer.masksToBounds = true
        
        assert(UserAccountModel.loadUserAccount() != nil ,"必须先授权登录")
        print("\(UserAccountModel.loadUserAccount())")
//        guard let url = NSURL(string:UserAccountModel.loadUserAccount()!.avatar_large!) else {
//            
//            return
//        }
        iocnImageView.image = UIImage(named: "avatar_default")
//        iocnImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "avatar_default"))
    }

    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
            iconBootomCons.constant = (UIScreen.mainScreen().bounds.height - iconBootomCons.constant)
            UIView.animateWithDuration(1.5, animations: { () -> Void in
                self.view.layoutIfNeeded()
                }) { (_) -> Void in
                    
                    UIView.animateWithDuration(1.0, animations: { () -> Void in
                        self.titleLabel.alpha = 1.0
                        }, completion: { (_) -> Void in
                            
                            // 跳转欢迎首页
                            let vc = UIStoryboard(name: "Main", bundle: nil
                                ).instantiateInitialViewController()
                            UIApplication.sharedApplication().keyWindow?.rootViewController = vc
                    })
        }
        
    }
    

}
