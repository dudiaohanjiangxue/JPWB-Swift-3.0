//
//  JPStatusModal.swift
//  JPWB
//
//  Created by KC on 16/10/19.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class JPStatusModal: NSObject {
    
    //MARK: - 属性
    ///创建的时间
    var created_at: String?
    ///微博的ID
    var id : Int = 0
    ///微博的正文
    var text: String?
    ///来源 <a href=\"http://app.weibo.com/t/feed/DitYZ\" rel=\"nofollow\">手机新浪网</a>
    var source: String? 
    ///user
    var user: JPUser?
    
    //MARK: - init
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
        if let userDict = dict["user"] as? [String: Any]{
        
           user = JPUser(dict: userDict)
        }
    }
 
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        get {
        
        return dictionaryWithValues(forKeys: ["created_at", "id", "text", "source"]).description
        }
    }
    
}
