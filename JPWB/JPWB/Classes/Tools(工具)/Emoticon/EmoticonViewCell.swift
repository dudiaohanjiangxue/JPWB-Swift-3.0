//
//  EmoticonViewCell.swift
//  emoticon
//
//  Created by KC on 16/10/28.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class EmoticonViewCell: UICollectionViewCell {
    
     fileprivate lazy var emoticonBtn: UIButton = UIButton()
    
    var emoticon: Emoticon? {
        didSet{
            guard let emoticon = emoticon else {
                return
            }
//            if emoticon.isRemove {
//                emoticonBtn.setTitle("", for: .normal)
//                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
//            } else if emoticon.isEmpty {
//                emoticonBtn.setTitle("", for: .normal)
//                emoticonBtn.setImage(UIImage(named: ""), for: .normal)
//            
//            }else{
//                emoticonBtn.setTitle(emoticon.emojiCode, for: .normal)
//                emoticonBtn.setImage(UIImage(contentsOfFile: emoticon.pngPath ?? ""), for: .normal)
//
//            }
            // 1.设置内容
            emoticonBtn.setTitle(emoticon.emojiCode, for: .normal)
            emoticonBtn.setImage(UIImage(contentsOfFile: emoticon.pngPath ?? ""), for: .normal)
            
            // 2.设置删除按钮
            if emoticon.isRemove {
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
            }
            
        }
    
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
       
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UI
extension EmoticonViewCell {

    fileprivate func setupUI() {
    
        contentView.addSubview(emoticonBtn)
        emoticonBtn.backgroundColor = UIColor.orange
        emoticonBtn.frame = contentView.frame.insetBy(dx: 5, dy: 5)
        emoticonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        emoticonBtn.isUserInteractionEnabled = false
    }

}
