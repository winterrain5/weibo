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

//    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
}
extension NewfeatureViewController:UICollectionViewDelegate {
    
    
}

extension NewfeatureViewController:UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
            return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4;
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
    
    var index: Int = 0
        {
        
        didSet {
            
            let name = "new_feature_\(index + 1)"
            iconView.image = UIImage(named: name)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    private func setupUI() {
        
        contentView.addSubview(iconView)
        iconView.image = UIImage(named: "new_feature_1")
        iconView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        
    }
    
    // 懒加载
    private lazy var iconView:UIImageView = UIImageView()
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