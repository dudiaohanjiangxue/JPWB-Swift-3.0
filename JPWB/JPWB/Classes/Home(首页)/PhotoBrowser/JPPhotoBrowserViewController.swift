//
//  JPPhotoBrowserViewController.swift
//  JPWB
//
//  Created by KC on 16/10/29.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
private let cellID = "cellID"

class JPPhotoBrowserViewController: UIViewController {
    //外界点击图片的索引
    var indexPath: IndexPath?
    //一条微博所有图片的url
    var picURLs: [URL]?
    //浏览图片的collectionView
    fileprivate lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: JPPhotoBrowserViewLayout())
    //关闭按钮
    fileprivate lazy var closeBtn : UIButton = UIButton(title: "关  闭", bgColor: UIColor.darkGray, fontSize: 14)
    
    //保存按钮
    fileprivate lazy var saveBtn = UIButton(title: "保  存", bgColor: UIColor.darkGray, fontSize: 14)
   
    init(indexPath: IndexPath, picURLs: [URL]) {
        self.indexPath = indexPath
        self.picURLs = picURLs
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.frame.size.width += 15
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.purple
       //1.初始化UI
        setupUI()
        
        //2.滚到相对应的图片
        collectionView.scrollToItem(at: indexPath!, at: .left, animated: false)
    }



}

//MARK: - UI
extension JPPhotoBrowserViewController {

    fileprivate func setupUI() {
        //1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        //2.设置frame
//        collectionView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
        collectionView.frame  = view.bounds
        
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        
        saveBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        
        //3.设置子控件的属性
        collectionView.dataSource = self
        //collectionView.delegate = self
        collectionView.register(JPPhotoBrowserViewCell.self, forCellWithReuseIdentifier: cellID)
        
        //4.监听点击
        saveBtn.addTarget(self, action: #selector(saveBtnDidClick), for: .touchUpInside)
        closeBtn.addTarget(self, action: #selector(closeBtnDidClick), for: .touchUpInside)
        
        
    }

}

//MARK: - UICollectionViewDataSource
extension JPPhotoBrowserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! JPPhotoBrowserViewCell
         cell.picURL = picURLs?[indexPath.item]
        cell.delegate = self
        return cell
    }


}

//MARK: - 点击事件的处理
extension JPPhotoBrowserViewController: NVActivityIndicatorViewable {
     //保存图片
    @objc fileprivate func saveBtnDidClick() {
      JPPrint("保存图片")
        let  cell = collectionView.visibleCells.first as! JPPhotoBrowserViewCell
        guard let image = cell.imageView.image else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //关闭图片浏览器
    @objc fileprivate func closeBtnDidClick() {
        
        JPPrint("关闭图片浏览器")
        dismiss(animated: true, completion: nil)
    }
   //image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
    @objc fileprivate func image(image : UIImage, didFinishSavingWithError error : NSError?, contextInfo : AnyObject) {
        let message = error != nil ? "保存失败" : "保存成功"
        
        startAnimating(CGSize(width: 60, height: 60), message: message, type: .lineScaleParty, color: UIColor.green, padding: nil, displayTimeThreshold: 0, minimumDisplayTime: 0)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            
            self.stopAnimating()
        }
    }
}

//MARK: - JPPhotoBrowserViewCellDelegate
extension JPPhotoBrowserViewController: JPPhotoBrowserViewCellDelegate {

    func imageViewClickForCell(cell: JPPhotoBrowserViewCell) {
        closeBtnDidClick()
    }
}

extension JPPhotoBrowserViewController: JPPhotoBrowserDismissDelegate {
    func imageViewForDismissView() -> UIImageView? {
        let imageView = UIImageView()
        let cell = collectionView.visibleCells.first as! JPPhotoBrowserViewCell
         let image = cell.imageView.image
        imageView.image = image
        let width = UIScreen.main.bounds.width
        let height = width / (image?.size.width)! * (image?.size.height)!
        let x : CGFloat = 0
        var y : CGFloat = (UIScreen.main.bounds.height - height) * 0.5
        
        y = y < 0 ? 0 : y
        imageView.frame = CGRect(x: x, y: y, width: width, height: height)
        // 4.设置imageView的内容模式
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
    
    func indexPathForDimissView() -> IndexPath? {
         let cell = collectionView.visibleCells.first as! JPPhotoBrowserViewCell
        return collectionView.indexPath(for: cell)
    }


}


class JPPhotoBrowserViewLayout : UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        itemSize = collectionView!.bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.isPagingEnabled = true
    }
}
