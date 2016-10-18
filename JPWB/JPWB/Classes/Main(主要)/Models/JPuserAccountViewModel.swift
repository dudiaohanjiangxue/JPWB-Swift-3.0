//
//  JPuserAccountViewModel.swift
//  JPWB
//
//  Created by KC on 16/10/18.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit
import SwiftyJSON

class JPuserAccountViewModel {
    //MARK: - 属性
    
    static let shared :JPuserAccountViewModel = JPuserAccountViewModel()
    
    var account : JPUserAccount?
    
    //判断是否登录
    var isLogin: Bool {
    
       return account != nil && !isExpire
    }
    
    //判断accessToken是否过期
    var isExpire :Bool {
        guard let expire_date = account?.expires_date else {
            return true
        }
        return expire_date.compare(Date()) == ComparisonResult.orderedAscending
    
    }
    
    //用户信息保存路径
    var accountPath : String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        return path.appending("accout.plist")
    
    }
    
    init() {
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? JPUserAccount
    }
    
    
}

extension JPuserAccountViewModel {

    ///获取授权令牌
    func requestToAccessTohen(code: String, finished: @escaping (Bool) -> ()) {
        
        JPHTTPRequestTool.shared.requestToAccessTohen(code: code) { (response, isSuccess) in
            if isSuccess {
                let userModel = JPUserAccount(dict: response as! [String: Any])
                self.loadUserInfo(userModel: userModel, finished: { (isSuccess) in
                    finished(isSuccess)
                })
                
            }
        }
        
    }
    ///加载用户信息
    private func loadUserInfo(userModel: JPUserAccount, finished: @escaping (Bool) -> ()) {
        
        guard let accessToken = userModel.access_token, let userID = userModel.uid  else {
            return
        }
        JPHTTPRequestTool.shared.requestUserInfo(accessToken: accessToken, userID: userID) { (response, isSuccess) in
            if !isSuccess {
                return
            }
            let json = JSON(response)
            userModel.avatar_large = json["avatar_large"].string
            userModel.screen_name = json["screen_name"].string
            NSKeyedArchiver.archiveRootObject(userModel, toFile: self.accountPath)
            self.account = userModel
            
            finished(true)
        }
        
    }

}
