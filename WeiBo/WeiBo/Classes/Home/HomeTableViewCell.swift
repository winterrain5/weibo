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

            print(cacluateSize())
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()

        // 设置正文最大宽度
        contentLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        iconImageView.layer.cornerRadius = 20
        iconImageView.layer.masksToBounds = true
    
    }

    // MARK: -内部方法
    // 计算cell 和 collectionView的尺寸
    private func cacluateSize() -> (CGSize,CGSize) {
        
        let count = statusViewModel?.thumbnail_pic?.count
        // 么有配图
        if  count ?? 0 == 0 {
            
            return (CGSizeZero,CGSizeZero)
        }
        // 一张配图
        if count == 1 {
            
            // 从缓存中获取已经下载的图片
            let  key = statusViewModel?.thumbnail_pic!.first!.absoluteString
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key)
            return (image.size,image.size)
            
        }
        // 四张配图
        let imgW :CGFloat = 90
        let imgH :CGFloat = 90
        let margin :CGFloat = 10
        if count == 4 {
            
            
            let col = 2
            
            
            let  width = imgW * CGFloat(col) + CGFloat(col - 1) * margin
            let  height = imgH * CGFloat(col) + CGFloat(col - 1) * margin
            return (CGSizeMake(imgW, imgH),CGSizeMake(width, height))
            
            
        }
        
        // 九张配图
        if count == 9 {
            
            let col = 3
            
            
            let  width = imgW * CGFloat(col) + CGFloat(col - 1) * margin
            let  height = imgH * CGFloat(col) + CGFloat(col - 1) * margin
            return (CGSizeMake(imgW, imgH),CGSizeMake(width, height))

        }
        
        // 其他张配图
        let col = 3
        let row = (count! - 1) / 3 + 1
        let  width = imgW * CGFloat(col) + CGFloat(col - 1) * margin
        let  height = imgH * CGFloat(row) + CGFloat(row - 1) * margin
        return (CGSizeMake(imgW, imgH),CGSizeMake(width, height))
    }
    
}

func getTextRectSize(text:NSString,font:UIFont,size:CGSize) -> CGRect {
    let attributes = [NSFontAttributeName: font]
    let option = NSStringDrawingOptions.UsesLineFragmentOrigin
    let rect:CGRect = text.boundingRectWithSize(size, options: option, attributes: attributes, context: nil)
    //        println("rect:\(rect)");
    return rect;
}
