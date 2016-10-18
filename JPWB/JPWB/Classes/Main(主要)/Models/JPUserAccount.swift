//
//  JPUserAccount.swift
//  JPWB
//
//  Created by KC on 16/10/17.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class JPUserAccount: NSObject {
    ///登录令牌
    var access_token: String?
    /// 令牌的生命周期(有效时间)
    var expires_in : TimeInterval = 0
    
    /// 用户ID
    var uid : String?
    
    init(access_token: String, expires_in: TimeInterval, uid: String) {
        self.access_token = access_token
        self.expires_in = expires_in
        self.uid = uid
    }
    
    init(dict: [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    //重写系统方法,多余的key和values不会报错
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    override var description: String {
        get {
        return dictionaryWithValues(forKeys: ["access_token","expires_in","uid"]).description
        }
     
    }

}
