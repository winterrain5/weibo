//
//  CSPhotoPickerController.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/12/24.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell"

class CSPhotoPickerController: UICollectionViewController {

/// 存放照片的数组
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }




    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return images.count + 1
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotoPickerCell
        cell.delegate = self
        cell.image = indexPath.item >= images.count ? nil : images[indexPath.item]
        return cell
    }


}

extension CSPhotoPickerController: PhotoPickerCellDelegate
{
    func photoPickerCellAddPhotoBtnClick(cell: PhotoPickerCell) {
        // 判断照片源是否可用
        guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) else {
            print("照片源不可用")
            return
        }
        // 创建照片控制器
        let  imagePicker = UIImagePickerController()
        // 设置照片源
        imagePicker.sourceType = .PhotoLibrary
        // 设置代理
        imagePicker.delegate = self
        imagePicker.editing = true
        // 弹出照片选择控制器
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func photoPickerCellRemovePhotoBtnClick(cell: PhotoPickerCell) {
        
        let index = collectionView!.indexPathForCell(cell)!.item
        images.removeAtIndex(index)
        
        collectionView?.reloadData()
    }
}
extension CSPhotoPickerController: UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        // 压缩照片 通过这种方式压缩照片 虽然图片尺寸会大大的减小  但是应用程序的内存大小并没有减低  最好的方式是通过画图的方式改变图片的尺寸
//        let imageData = UIImageJPEGRepresentation(image, 0.1)
//        let newImage = UIImage(data: imageData!)!
        let newImage = drawImage(image, width: 400)
        // 显示照片
        images.append(newImage)
        
        collectionView?.reloadData()
    }
    
    func drawImage(image: UIImage,width: CGFloat) -> UIImage
    {
        // 获取图片上下文
        let  height = (image.size.height / image.size.width) * width
        let size = CGSizeMake(width, height)
        
        // 开启图片上下文
        UIGraphicsBeginImageContext(size)
        
        // 将图片画到上下文中
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        
        // 从上下文中获取新的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 关闭上下文
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
@objc
protocol PhotoPickerCellDelegate: NSObjectProtocol
{
    optional func photoPickerCellAddPhotoBtnClick(cell: PhotoPickerCell)
    optional func photoPickerCellRemovePhotoBtnClick(cell: PhotoPickerCell)

}
class PhotoPickerCell:UICollectionViewCell
{
    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    var delegate: PhotoPickerCellDelegate?
    var image:UIImage? {
        didSet {
            if image == nil {
                addPhotoBtn.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
                
                addPhotoBtn.setBackgroundImage(UIImage(named: "compose_pic_add_highlighted"), forState: UIControlState.Highlighted)
                addPhotoBtn.userInteractionEnabled = true
                closeBtn.hidden = true
            } else {
                
                addPhotoBtn.setBackgroundImage(image, forState: UIControlState.Normal)
                addPhotoBtn.userInteractionEnabled = true
                closeBtn.hidden = false
            }
        }
    }
    //MARK:- 选择照片
    @IBAction func addPhotoBtnClick(sender: UIButton) {
        if let tempdelegate = delegate {
            if tempdelegate.respondsToSelector("photoPickerCellAddPhotoBtnClick:") {
                tempdelegate.photoPickerCellAddPhotoBtnClick!(self)

            }
        }
    }
    // MARK:- 删除照片
    @IBAction func closeBtnClick(sender: AnyObject) {
        if let tempdelegate = delegate {
            if tempdelegate.respondsToSelector("photoPickerCellRemovePhotoBtnClick:") {
                tempdelegate.photoPickerCellRemovePhotoBtnClick!(self)
                
            }
        }
    }
}
class PhotoPickerCollectionViewLayout:UICollectionViewFlowLayout
{
    override func prepareLayout() {
        super.prepareLayout()
        let margin: CGFloat = 20
        let col: CGFloat = 3
        
        let itemWH = (collectionView!.bounds.width - (col + 1) * margin)/3
        itemSize = CGSizeMake(itemWH, itemWH)
        
        minimumLineSpacing = margin
        minimumInteritemSpacing = margin
        
        sectionInset = UIEdgeInsetsMake(margin, margin, 0, margin)
    }
}
