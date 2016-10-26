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


class CSBrowserCell:UICollectionViewCell,UIScrollViewDelegate {
    
    var imageURL: NSURL? {
        
        didSet {
        
            // 显示菊花
            indicatorView.startAnimating()
            
            // 重置容器的数据
            self.resetView()
            
            // 设置图片=
            imageView.sd_setImageWithURL(imageURL, completed: { (image, error, _, _) -> Void in
                
                    self.indicatorView.stopAnimating()
                
                    let width = UIScreen.mainScreen().bounds.width
                    let height = UIScreen.mainScreen().bounds.height
                    // 计算当前图片的宽高比
                    let scale = image.size.height / image.size.width
                    // 利用宽高比乘以屏幕宽度，等比缩放图片
                    let imageHeight = scale * width
                    
                    self.imageView.frame = CGRect(origin: CGPointZero, size: CGSize(width: width, height: imageHeight))
                    
                    // 判断是长图还是短图
                    if imageHeight < height { // 短图
                        
                        // 设置内边距
                        let offsetY = (height - imageHeight) * 0.5
                        self.scrollView.contentInset = UIEdgeInsetsMake(offsetY, 0, offsetY, 0)
                        
                    } else {
                        
                        self.scrollView.contentSize = CGSize(width: width, height: imageHeight)
                        
                    }
                    
                  
//                    self.imageView.sizeToFit()
                })
            
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        
        // 添加子控件
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        contentView.addSubview(indicatorView)
        
        // 布局子控件
        scrollView.frame = UIScreen.mainScreen().bounds
        indicatorView.center = contentView.center
    }
    
    private func resetView() {
        
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.contentSize = CGSizeZero
        scrollView.contentOffset = CGPointZero
        
        imageView.transform = CGAffineTransformIdentity
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView: UIScrollView = {
       
        let sc = UIScrollView()
        sc.maximumZoomScale = 2.0
        sc.minimumZoomScale = 0.5
        sc.delegate = self
        return sc
        
    }()

    private lazy var imageView: UIImageView = UIImageView()
    
    private lazy var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    
    // MARK: -UIScrollViewDelegate
    
    // 告诉scrollView 哪个view需要缩放
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
    
    // 每次缩放都会调用的方法
    func scrollViewDidZoom(scrollView: UIScrollView) {
        let width = UIScreen.mainScreen().bounds.width
        let height = UIScreen.mainScreen().bounds.height
        
        var offsetY = (height - imageView.frame.height) * 0.5
        var offsetX = (width - imageView.frame.width) * 0.5
        
        
        // 边距小于0时不计算 以便于放大后能拖动
        offsetY = (offsetY < 0) ? 0 : offsetY
        offsetX = (offsetX < 0) ? 0 : offsetX
         
        scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, offsetY, offsetX)
    }
}


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
