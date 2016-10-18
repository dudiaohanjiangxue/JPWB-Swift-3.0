//
//  UiBarButtonItem.swift
//  JPWB
//
//  Created by KC on 16/10/11.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(imageName : String, target : Any?, action : Selector) {
       
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage.init(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        btn.addTarget(target, action: action, for: .touchUpInside)
        self.init(customView : btn)
    }
    
}
