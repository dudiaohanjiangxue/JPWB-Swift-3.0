//
//  JPPicPickerViewCell.swift
//  JPWB
//
//  Created by KC on 16/10/25.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

//MARK: - 代理传值

protocol PicPickerViewCellDelegate {
      func PicPickerViewCellAddPhotoBtnClickFor(cell: JPPicPickerViewCell)
      func PicPickerViewCellCancalBtnClickFor(cell: JPPicPickerViewCell)
}

class JPPicPickerViewCell: UICollectionViewCell {
   /**代理*/
    var delegate: PicPickerViewCellDelegate?
    //图片的按钮
    @IBOutlet weak var imageBtn: UIButton!
    /**删除按钮*/
    @IBOutlet weak var cancalBtn: UIButton!
    
    var image: UIImage? {
        didSet{
            if image == nil {
              imageBtn.setBackgroundImage(UIImage(named: "compose_pic_add"), for: .normal)
                imageBtn.isUserInteractionEnabled = true
                cancalBtn.isHidden = true
            }else{
              imageBtn.setBackgroundImage(image, for: .normal)
             imageBtn.isUserInteractionEnabled = false
            cancalBtn.isHidden = false
            }
        
        }
    
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }


    @IBAction func addPicBtnDidClick(_ sender: AnyObject) {
        
        delegate?.PicPickerViewCellAddPhotoBtnClickFor(cell: self)
    }
    
    @IBAction func cancalPicBtnDidClick(_ sender: AnyObject) {
        delegate?.PicPickerViewCellCancalBtnClickFor(cell: self)
    }
    
}
