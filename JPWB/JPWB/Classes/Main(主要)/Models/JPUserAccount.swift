//
//  JPUserAccount.swift
//  JPWB
//
//  Created by KC on 16/10/17.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class JPUserAccount: NSObject, NSCoding {
    
    //MARK: - 属性
    ///登录令牌
    var access_token: String?
    /// 令牌的生命周期
    var expires_in : TimeInterval = 0 {
        didSet {
           expires_date = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    /// 用户ID
    var uid : String?
    
    ///令牌的过期日期
    var expires_date : Date?
    
    ///用户头像
    var avatar_large: String?
    
    ///用户昵称
    var screen_name : String?
    
    
    init(dict: [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    //重写系统方法,多余的key和values不会报错
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    override var description: String {
        get {
        return dictionaryWithValues(forKeys: ["access_token","expires_date","uid", "screen_name", "avatar_large"]).description
        }
     
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(screen_name, forKey: "screen_name")
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? Date
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
    }
}
