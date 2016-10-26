//
//  JPPicPickerViewController.swift
//  JPWB
//
//  Created by KC on 16/10/25.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

private let cellID = "cellID"
class JPPicPickerViewController: UICollectionViewController {
    //MARK: - 属性
     lazy var images: [UIImage] = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = UIColor.lightGray
        //注册cell
        self.collectionView!.register(UINib(nibName: String(describing: JPPicPickerViewCell.self), bundle: nil), forCellWithReuseIdentifier: cellID)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

//MARK: - 数据源方法
extension JPPicPickerViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! JPPicPickerViewCell
        cell.backgroundColor = UIColor.red
        cell.image = indexPath.item <= images.count - 1 ? images[indexPath.item] : nil
        cell.delegate = self
        return cell
    }
}

//MARK: - PicPickerViewCellDelegate
extension JPPicPickerViewController : PicPickerViewCellDelegate {
    //添加图片
    func PicPickerViewCellAddPhotoBtnClickFor(cell: JPPicPickerViewCell) {
        //1.判断照片源石头可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
          return
        }
        //2.创建照片选择控制器
        let picPickerVC = UIImagePickerController()
        
        //3.选择照片源
        picPickerVC.sourceType = .photoLibrary
        //4.设置代理
        picPickerVC.delegate = self
        //5.弹出控制器
        present(picPickerVC, animated: true, completion: nil)
        
    }
    
    //删除相片
    func PicPickerViewCellCancalBtnClickFor(cell: JPPicPickerViewCell) {
        
      let indexPath = collectionView!.indexPath(for: cell)!
        images.remove(at: indexPath.item)
        collectionView?.reloadData()
    }
    
}

//MARK: - UIImagePickerControllerDelegate

extension JPPicPickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        images.append(image)
        collectionView?.reloadData()
        picker.dismiss(animated: true, completion: nil)
        
        
    }

}


//MARK: - 自定义collectionView的布局
class JPPicpickerViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        let itemPadding : CGFloat = 15
        let itemWH = (UIScreen.main.bounds.width - 4 * itemPadding) / 3
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumLineSpacing = itemPadding
        minimumInteritemSpacing = itemPadding
        collectionView?.contentInset = UIEdgeInsets(top: itemPadding, left: itemPadding, bottom: itemPadding, right: itemPadding)
    }
}
