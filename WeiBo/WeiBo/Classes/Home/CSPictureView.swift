//
//  CSPictureView.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/10/24.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit
import SDWebImage
class CSPictureView: UICollectionView,UICollectionViewDataSource,UICollectionViewDelegate {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dataSource = self
        self.delegate = self
    }
    @IBOutlet weak var picCollectionViewHCons: NSLayoutConstraint!
    @IBOutlet weak var picCollectionViewWCons: NSLayoutConstraint!
    @IBOutlet weak var flowLaout: UICollectionViewFlowLayout!
    var statusViewModel:StatuesViewModel? {
        
        // 重写set 方法
        didSet {
            
            // 更新配图
            reloadData()
            
            
            let (itemSize,clvSize) = cacluateSize()
            // 更新配图的尺寸
            if itemSize != CGSizeZero {
                // 更新cell 的尺寸
                flowLaout.itemSize = itemSize
            }
            // 更新collectionView的
            picCollectionViewHCons.constant = clvSize.height
            picCollectionViewWCons.constant = clvSize.width

            
        }
    }
    
    // MARK: -UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return statusViewModel?.thumbnail_pic?.count ?? 0
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pictureCell", forIndexPath: indexPath) as! HomePictureCell
        cell.url = statusViewModel?.thumbnail_pic![indexPath.item]
        return cell
        
    }
    
    // MARK: -UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        let url = statusViewModel?.bmiddle_pic![indexPath.item]
//        print(url)
        NSNotificationCenter.defaultCenter().postNotificationName(CSShowPhotoBrowserController, object: self, userInfo: ["bmiddle":statusViewModel!.bmiddle_pic!,"indexPath":indexPath])
    }
    
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

class HomePictureCell:UICollectionViewCell {
    
    var url:NSURL? {
        
        didSet {
            
            customeImageView.sd_setImageWithURL(url)
        }
    }
    
    @IBOutlet weak var customeImageView: CSProgressImageView!
    
    
    
}
