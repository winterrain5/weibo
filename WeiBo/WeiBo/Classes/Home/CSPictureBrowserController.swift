//
//  CSPictureBrowserController.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/10/25.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit
import SDWebImage
class CSPictureBrowserController: UIViewController {
    var bmiddle_pic:[NSURL]
    var indexPath:NSIndexPath
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
    }
    
    init(pics:[NSURL],indexpath:NSIndexPath) {
        
        self.bmiddle_pic = pics
        self.indexPath = indexpath
        
        // 自定义构造方法时不一定要调用super.init ,需要调用当前类设计构造方法
        super.init(nibName: nil, bundle: nil)
        // 初始化UI
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        // 添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
        // 布局子控件
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        var cons = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView":collectionView])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView":collectionView])
        
        view.addConstraints(cons)
        
        closeButton.frame = CGRectMake(20,view.frame.size.height - 35 - 30, 60, 35)
        saveButton.frame = CGRectMake(view.frame.size.width - 20 - 60,view.frame.size.height - 35 - 30, 60, 35)
    }
    
    private lazy var collectionView:UICollectionView = {
       
        let clv = UICollectionView(frame: CGRectZero,collectionViewLayout: CSBrowserLayout())
        clv.dataSource = self
        clv.registerClass(CSBrowserCell.self, forCellWithReuseIdentifier: "browserCell")
        return clv
    }()
    
    private lazy var closeButton: UIButton = {
       
        let btn = UIButton()
        btn.setTitle("关闭", forState: UIControlState.Normal)
        btn.addTarget(self, action:Selector("closeButtonClick"), forControlEvents: UIControlEvents.TouchUpInside)
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor.whiteColor().CGColor
        btn.layer.borderWidth = 1
        btn.backgroundColor = UIColor.lightGrayColor()
        return btn
    }()
    private lazy var saveButton: UIButton = {
        
        let btn = UIButton()
        btn.setTitle("保存", forState: UIControlState.Normal)
        btn.addTarget(self, action:Selector("saveButtonClick"), forControlEvents: UIControlEvents.TouchUpInside)
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor.whiteColor().CGColor
        btn.layer.borderWidth = 1
        btn.backgroundColor = UIColor.lightGrayColor()
        return btn
    }()
    
    @objc private func closeButtonClick() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func saveButtonClick() {
        
        
    }
    
    
    
}
extension CSPictureBrowserController: UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bmiddle_pic.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("browserCell", forIndexPath: indexPath) as? CSBrowserCell
        cell?.imageURL = bmiddle_pic[indexPath.item]
        
        return cell!
    }
}

//MARK: -自定义布局
class CSBrowserLayout:UICollectionViewFlowLayout
{
    override func prepareLayout() {
        itemSize = UIScreen.mainScreen().bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}
