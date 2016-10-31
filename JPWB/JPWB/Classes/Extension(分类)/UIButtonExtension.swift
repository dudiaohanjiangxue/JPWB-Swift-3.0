//
//  UIButtonExtension.swift
//  JPWB
//
//  Created by KC on 16/10/11.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit


extension UIButton {
    
    ///遍历构造函数
    convenience init(imageName: String, bgImageName: String) {
        self.init()
        setImage(UIImage(named: imageName), for: UIControlState())
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        setBackgroundImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        sizeToFit()
    }
    
    convenience init(title: String, bgColor: UIColor, fontSize: CGFloat) {
        self.init()
        
        self.setTitle(title, for: .normal)
        self.backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
    
    ///类方法
    class func crateBtn(imageName: String, bgImageName: String) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        btn.setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        btn.setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        return btn
    }
}
