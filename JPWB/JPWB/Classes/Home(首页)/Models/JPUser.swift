//
//  JPUser.swift
//  JPWB
//
//  Created by KC on 16/10/19.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class JPUser: NSObject {
    //MARK: - 属性
    ///用户ID
//    var id: String?
    ///昵称
    var screen_name : String?
    ///头像地址
    var profile_image_url: String?
    ///认证类型
    var verified_type: Int = -1
    
    ///会员等级
    var mbrank: Int = 0 
   
    
    //MARK: - init
    init(dict: [String: Any]) {
        super.init()
        JPPrint(dict)
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    
    }
    
    
    
}
