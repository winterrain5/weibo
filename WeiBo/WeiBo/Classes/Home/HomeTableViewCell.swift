//
//  HomeTableViewCell.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/9/7.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit
import SDWebImage
class HomeTableViewCell: UITableViewCell {
    // 来源
    @IBOutlet weak var souceLabel: UILabel!
    // 正文
    @IBOutlet weak var contentLabel: UILabel!
    // 时间
    @IBOutlet weak var timeLabel: UILabel!
    // 昵称
    @IBOutlet weak var namelabel: UILabel!
    // vip图标
    @IBOutlet weak var vipImageView: UIImageView!
    // 认证图标
    @IBOutlet weak var verifiedImageView: UIImageView!
    // 头像
    @IBOutlet weak var iconImageView: UIImageView!
    
    // 行高
    var cellH:CGFloat?
    
    var statusViewModel:StatuesViewModel? {
        
        // 重写set 方法
        didSet {
            
            if let urlStr = statusViewModel?.status.user?.profile_image_url {
                
                let url = NSURL(string: urlStr)
                iconImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "avatar_default"))
            }
            
            namelabel.text = statusViewModel?.status.user?.screen_name
            
          
            timeLabel.text = statusViewModel?.create_time
         
                
            souceLabel.text = statusViewModel?.source_str
            
            contentLabel.text = statusViewModel?.status.text
            
            
            verifiedImageView.image = statusViewModel?.verifiedImage
            
            vipImageView.image = statusViewModel?.mbrankImage

            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()

    // 设置正文最大宽度
        contentLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        iconImageView.layer.cornerRadius = 20
        iconImageView.layer.masksToBounds = true
    
    }

    
}

func getTextRectSize(text:NSString,font:UIFont,size:CGSize) -> CGRect {
    let attributes = [NSFontAttributeName: font]
    let option = NSStringDrawingOptions.UsesLineFragmentOrigin
    let rect:CGRect = text.boundingRectWithSize(size, options: option, attributes: attributes, context: nil)
    //        println("rect:\(rect)");
    return rect;
}
