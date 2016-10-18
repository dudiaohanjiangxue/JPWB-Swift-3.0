//
//  JPHTTPRequestTool.swift
//  JPWB
//
//  Created by KC on 16/10/13.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit
import Alamofire

typealias finisedCallBack = ((Any?, Bool) -> ())

class JPHTTPRequestTool: NSObject {
    ///单例
    static let shared : JPHTTPRequestTool = JPHTTPRequestTool()
    
    ///网络请求
    func request(
        _ url: URLConvertible,
        method: HTTPMethod = .post,
        parameters: Parameters? = nil,
        finished: @escaping finisedCallBack) {
        
        let paraneterEncoding = URLEncoding.default
        ///默认的请求方式
        Alamofire.request(url, method: method, parameters: parameters, encoding: paraneterEncoding, headers: nil).responseJSON { (dataRespose: DataResponse<Any>) in
            print(dataRespose.request)
            print(dataRespose.response)
            print(dataRespose.result)
            print(dataRespose.result.value)
            print(dataRespose.timeline)
            
            finished(dataRespose.result.value, dataRespose.result.isSuccess)
        }
    }
}

extension JPHTTPRequestTool {
    
    ///获取授权的AccessToken
    func requestToAccessTohen(code: String, finished: @escaping finisedCallBack) {
        
        let parameters = ["client_id" : OAuthInfo.app_key, "client_secret" : OAuthInfo.app_secret, "grant_type" : "authorization_code", "code" : code, "redirect_uri" : OAuthInfo.redirect_uri]
        
        request(JPRequestURLString.access_token, method: .post, parameters: parameters) { (response, isSuccess) in
            finished(response, isSuccess)
        }
        
    }
    
    ///获取用户的信息
    func requestUserInfo(accessToken: String, userID: String, finished: @escaping finisedCallBack) {
        let params = ["access_token": accessToken, "uid": userID]
        
        request(JPRequestURLString.userInfo, method: .get, parameters: params) { (response, isSuccess) in
            finished(response, isSuccess)
        }
    }


}
