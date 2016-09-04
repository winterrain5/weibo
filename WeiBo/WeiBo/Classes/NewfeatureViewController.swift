//
//  NewfeatureViewController.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/9/1.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit
import SnapKit
class NewfeatureViewController: UIViewController {

    var maxCount = 4
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
}
extension NewfeatureViewController:UICollectionViewDelegate {
    
    
    // cell 完全显示调用的代理方法
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        // 这里传入的cell 和 index 都是上一个页面的
        
        // 当前已经显示的cell 的index
        let index = collectionView.indexPathsForVisibleItems().last!
        let currentCell = collectionView.cellForItemAtIndexPath(index) as! NewfeatureCell!
        if index.item == (maxCount - 1) {
            
            print("asdfa")
            currentCell.startBtnAnimation()
            
        }

    }
    
}

extension NewfeatureViewController:UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
            return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxCount;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
        let  cell = collectionView.dequeueReusableCellWithReuseIdentifier("newfeaturecell", forIndexPath: indexPath) as! NewfeatureCell
        
        cell.index = indexPath.item
        
        cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColor.redColor() : UIColor.purpleColor()
        return cell
        
    }
}

//MARK: -自定义cell
class NewfeatureCell:UICollectionViewCell {
    
    func startBtnAnimation() {
        starButton.hidden = false
        /**
        <#Description#>
        
        - parameter <Tduration:             动画时间
        - parameter delay:                  延迟时间
        - parameter usingSpringWithDamping: 振幅 0.0~1.0 值越小震动越厉害
        - parameter initialSpringVelocity:  加速度 值越大 震动越厉害
        - parameter options:                附加属性
        - parameter animations:             执行动画的block
        - parameter completion:             执行完毕后回调的block
        
        - returns:
        */
        starButton.userInteractionEnabled = false
        starButton.transform = CGAffineTransformMakeScale(0, 0)
        UIView.animateWithDuration(2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue:0), animations: { () -> Void in
            
            self.starButton.transform = CGAffineTransformIdentity
            }, completion: { (_) -> Void in
                self.starButton.userInteractionEnabled = true
                
        })

        
    }
    
    var index: Int = 0
        {
        
        didSet {
            
            let name = "new_feature_\(index + 1)"
            iconView.image = UIImage(named: name)
            starButton.hidden = true
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    private func setupUI() {
        
        contentView.addSubview(iconView)
        contentView.addSubview(starButton)
        iconView.image = UIImage(named: "new_feature_1")
        iconView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        starButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView.snp_bottom).offset(-160)
        }
        
        
    }
    
    @objc private func starBtnClick() {
        
        // 跳转欢迎首页
        let vc = UIStoryboard(name: "Main", bundle: nil
            ).instantiateInitialViewController()
        UIApplication.sharedApplication().keyWindow?.rootViewController = vc
        
    }
    
    // 懒加载
    private lazy var iconView:UIImageView = UIImageView()
    
    private lazy var starButton:UIButton = {
        
        let btn = UIButton(imageName: nil, backgroundImageName: "new_feature_finish_button")
        btn.setTitle("进入微博", forState: UIControlState.Normal)
        btn.addTarget(self, action: Selector("starBtnClick"), forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn;
    }()
}

// MARK: -自定义布局
class NewfeatureFlowLayout:UICollectionViewFlowLayout {
    
    
    // 准备布局
    override func prepareLayout() {
        
        // 大小
        itemSize = UIScreen.mainScreen().bounds.size
        
        // 间距
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        // 滚动方向
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 设置分页
        collectionView?.pagingEnabled = true
        
        // 禁用回弹
        collectionView?.bounces = false
        
        // 去除滚动条
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false 
        
    }
    
}