//
//  JPPicCollectionView.swift
//  JPWB
//
//  Created by KC on 16/10/20.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit
import Kingfisher
private let pic_CollectionViewCellID = "pic_CollectionViewCellID"

class JPPicCollectionView: UICollectionView {
     /**图片的URL*/
    var picUrls: [URL] = [URL](){
        didSet{
            //计算图片的collectionView大小
            let (width, height) = calculatePicCollectionSize(count: picUrls.count)
            picViewWidthConst.constant = width
            picViewHeghtConst.constant = height
            
            reloadData()
        }
     
    }
    
    @IBOutlet weak var picViewWidthConst: NSLayoutConstraint!
    @IBOutlet weak var picViewHeghtConst: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        dataSource = self
        delegate = self
        isScrollEnabled = false
        
       
        
    }

}


//MARK: - UICollectionViewDataSource

extension JPPicCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pic_CollectionViewCellID, for: indexPath) as! JPPicCollectionViewCell
        cell.picUrl = picUrls[indexPath.item]
//        JPPrint(indexPath.item, picUrls[indexPath.item])
        return cell
        
    }



}

//MARK: - UICollectionViewDelegate
extension JPPicCollectionView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //要传出去的信息
        let userinfo = [PhotoBrowserVcNote.showPhotoBrowserVcNoteIndex: indexPath, PhotoBrowserVcNote.showPhotoBrowserVcNotePicURLs: picUrls] as [String : Any]
        //发送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PhotoBrowserVcNote.name), object: self, userInfo: userinfo)
        
    }
}

//MARK: - 自定义的方法
extension JPPicCollectionView {
    fileprivate func calculatePicCollectionSize(count: Int) -> (CGFloat, CGFloat) {
        //1.没有图片
        if count == 0 {
            return (0, 0)
        }
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        //2.一张图片
        if count == 1 {
            let imageKey =  picUrls.last!.absoluteString
            let diskImage = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: imageKey, options: [])//有时候取不出相片
            guard let image = diskImage else {
                JPPrint("没有渠道相片\(imageKey)")
                return (0, 0)
            }
            let imageW = image.size.width * 2
            let imageH = image.size.height * 2
            
            
            layout.itemSize = CGSize(width: imageW, height: imageH)
            layout.minimumLineSpacing = JPHomeConst.pading
            layout.minimumInteritemSpacing = JPHomeConst.pading
            
            JPPrint(imageW, imageH)
            return (imageW, imageH)
            
        }
        
        
        
        let imageWH  = (UIScreen.main.bounds.width - 2 * JPHomeConst.edgeMargin - 2 * JPHomeConst.pading) / 3
        layout.itemSize = CGSize(width: imageWH, height: imageWH)
        layout.minimumLineSpacing = JPHomeConst.pading
        layout.minimumInteritemSpacing = JPHomeConst.pading
        
        
//        let imageWH = (UIScreen.main.bounds.width - 2 * JPHomeConst.edgeMargin - 2 * JPHomeConst.pading) / 3
        
        
        //3. 四张图片
        if  count == 4 {
            let width = 2 * imageWH + JPHomeConst.pading
            let height = 2 * imageWH + JPHomeConst.pading
            return (width, height)
        }
        
        let row = CGFloat((count - 1) / 3 + 1)
        let width = imageWH * 3 + JPHomeConst.pading * 2
        let height = imageWH * row + JPHomeConst.pading * (row - 1)
        return (width, height)
       
        
        
        
    }

}

extension JPPicCollectionView : JPPhotoBrowserPresentedDelegate {

    func startRectForPresentedView(indexPath: IndexPath) -> CGRect? {
        let cell = cellForItem(at: indexPath)!
        let startFrame = self.convert(cell.frame, to: UIApplication.shared.keyWindow)
        return startFrame
    }
    
    
    func endRectForPresentedView(indexPath: IndexPath) -> CGRect? {
        //1.取出indexPath对应的图片
        let picURL = picUrls[indexPath.item]
        guard let image =  KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: picURL.absoluteString) else {
            JPPrint("取不出相片")
            return nil
        }
        let width = UIScreen.main.bounds.width
        let height = width * image.size.height / image.size.width
        let x : CGFloat = 0
        var y : CGFloat = (UIScreen.main.bounds.height - height) * 0.5
        y = y < 0 ? 0 : y
        return CGRect(x: x, y: y, width: width, height: height)
        
    }
    
    func imageViewForPresentedView(indexPath: IndexPath) -> UIImageView? {
        let imageView = UIImageView()
        let picURL = picUrls[indexPath.item]
        guard let image =  KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: picURL.absoluteString) else {
            JPPrint("取不出相片")
            return nil
        }
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }

}


class JPPicCollectionViewCell: UICollectionViewCell {
    /**图片路径*/
    var picUrl: URL?{
        didSet{
         imageView.kf.setImage(with: picUrl, placeholder: UIImage(named: "empty_picture"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
}

