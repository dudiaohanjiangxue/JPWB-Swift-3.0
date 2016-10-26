//
//  JPComposeTitleView.swift
//  JPWB
//
//  Created by KC on 16/10/24.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit
import SnapKit
class JPComposeTitleView: UIView {
    fileprivate lazy var postStatusLabel: UILabel = UILabel()
    fileprivate lazy var screenNameLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: -  初始UI设置
extension JPComposeTitleView {
    fileprivate func setupUI() {
        //1.添加子控件
        addSubview(postStatusLabel)
        addSubview(screenNameLabel)
        //2.设置Frame
        
        postStatusLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        screenNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(postStatusLabel.snp.bottom).offset(3)

        }
        //3.设置属性
        postStatusLabel.textAlignment = .center
        postStatusLabel.text = "发微博"
        postStatusLabel.font = UIFont.systemFont(ofSize: 14)
        screenNameLabel.textColor = UIColor.gray
        screenNameLabel.textAlignment = .center
        screenNameLabel.text = JPuserAccountViewModel.shared.account?.screen_name
        screenNameLabel.font = UIFont.systemFont(ofSize: 13)
    
    }

}
