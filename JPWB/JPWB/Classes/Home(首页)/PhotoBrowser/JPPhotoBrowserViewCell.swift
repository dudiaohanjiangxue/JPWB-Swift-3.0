//
//  JPPhotoBrowserViewCell.swift
//  JPWB
//
//  Created by KC on 16/10/29.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit
import Kingfisher

protocol JPPhotoBrowserViewCellDelegate {
    func imageViewClickForCell(cell: JPPhotoBrowserViewCell)
}

class JPPhotoBrowserViewCell: UICollectionViewCell {
    //MARK: - 属性
    ///图片的地址
    var picURL: URL? {
    
        didSet{
            guard let picURL = picURL else {
                return
            }
            //设置内容
           setupUIContent(picURL: picURL)
        }
    }
    
    //
    fileprivate lazy var scrollview: UIScrollView = UIScrollView()
     lazy var imageView: UIImageView = UIImageView()
    fileprivate lazy var progressView: JPPhotoBrowserProgressView = JPPhotoBrowserProgressView()
    
    //代理
    var delegate: JPPhotoBrowserViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
}


//MARK: - UI
extension JPPhotoBrowserViewCell {
    fileprivate func setupUI() {
        //1.添加子控件
        contentView.addSubview(scrollview)
        scrollview.addSubview(imageView)
        contentView.addSubview(progressView)
        
        //2.设置frame
        scrollview.frame = contentView.bounds
        scrollview.frame.size.width -= 15
        progressView.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        progressView.center = CGPoint(x: contentView.bounds.width * 0.5 - 7.5, y: contentView.bounds.height * 0.5)
        //3.初始设置
        progressView.isHidden = true
        progressView.backgroundColor = UIColor.clear
        //4.图片的缩放
        scrollview.minimumZoomScale = 0.5
        scrollview.maximumZoomScale = 2.0
        scrollview.delegate = self
        //4.给imageView添加手势
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewDidClick))
        imageView.addGestureRecognizer(tap)
        
    }

}


//MARK: - 设置界面内容
extension JPPhotoBrowserViewCell {

    fileprivate func setupUIContent(picURL: URL) {
       //1.取出image
        guard  let image = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: picURL.absoluteString) else {
            JPPrint("取不出相片")
            return
        }
        //2.计算图片的尺寸
        let screenW = UIScreen.main.bounds.width
        let screenH = UIScreen.main.bounds.height
        let imageViewH = screenW * image.size.height / image.size.width
        imageView.frame = CGRect(x: 0, y: 0, width: screenW, height: imageViewH)
        //3.设置内边距
        if imageViewH > screenH {
            scrollview.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        }else {
            let topInset = (screenH - imageViewH) * 0.5
           scrollview.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        }
        
        scrollview.contentSize = CGSize(width: 0, height: imageViewH)
        //4.下载大图
        progressView.isHidden = false
        let middlePicURL = getMiddlePicURL(smallPicUrl: picURL)
        imageView.kf.setImage(with: middlePicURL, placeholder: image, options: [], progressBlock: { (current, total) in
            self.progressView.progress = CGFloat(current) / CGFloat(total)
            }) { (_, _, _, _) in
                self.progressView.isHidden = true
        }
      
    }
    
    ///根据小图的URL转换成大图的URL
    private func getMiddlePicURL(smallPicUrl: URL) -> URL {
          let urlString = smallPicUrl.absoluteString
        
        let middleURLString = urlString.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        
        return URL(string: middleURLString)!
    }

}

//MARK: - UIScrollViewDelegate
extension JPPhotoBrowserViewCell: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        var insetV = (UIScreen.main.bounds.height - view!.frame.height) * 0.5
        insetV = insetV < 0 ? 0 : insetV
        
        var insetH = (UIScreen.main.bounds.width - view!.frame.width) * 0.5
        insetH = insetH < 0 ? 0 : insetH
        //重新调整contentInset
        scrollview.contentInset = UIEdgeInsets(top: insetV, left: insetH, bottom: insetV, right: insetH)
        
    }
}

extension JPPhotoBrowserViewCell {
    @objc fileprivate func imageViewDidClick() {
      
    delegate?.imageViewClickForCell(cell: self)
    }

}
