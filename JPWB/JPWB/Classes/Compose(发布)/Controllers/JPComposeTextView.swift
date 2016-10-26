//
//  JPComposeTextView.swift
//  JPWB
//
//  Created by KC on 16/10/24.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class JPComposeTextView: UITextView {
   
    //MARK: - 懒加载属性
    lazy var placeHolderLabel: UILabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       setupUI()
    }
}

//MARK: - 初始UI
extension JPComposeTextView {

    fileprivate func setupUI() {
    
       addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(10)
        }
        placeHolderLabel.text = "分享新鲜事"
        placeHolderLabel.font = UIFont.systemFont(ofSize: 14)
        placeHolderLabel.textColor = UIColor.lightGray
        
        self.textContainerInset = UIEdgeInsets(top: 8, left: 7, bottom: 0, right: 7)
    }
}
