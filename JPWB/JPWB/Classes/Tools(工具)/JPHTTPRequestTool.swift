//
//  JPHTTPRequestTool.swift
//  JPWB
//
//  Created by KC on 16/10/13.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit
import Alamofire

class JPHTTPRequestTool: NSObject {
    
    static let shared : JPHTTPRequestTool = JPHTTPRequestTool()
    
    ///网络请求
    class func request(
        _ url: URLConvertible,
        method: HTTPMethod = .post,
        parameters: Parameters? = nil,
         finished: @escaping (Any?, Bool) -> ()) {
        //定义
       let paraneterEncoding = URLEncoding.default
        Alamofire.request(url, method: method, parameters: parameters, encoding: paraneterEncoding, headers: nil).responseJSON { (dataRespose: DataResponse<Any>) in
            print(dataRespose.request)
            print(dataRespose.response)
            print(dataRespose.result)
            print(dataRespose.data)
            print(dataRespose.timeline)
           
            finished(dataRespose.result.value, dataRespose.result.isSuccess)
        
            
        }
    
    }
    
    class func requestToAccessTohen(code: String, finished: @escaping (DataResponse<Any>) -> ()) {
        
        let parameters = ["client_id" : OAuthInfo.app_key, "client_secret" : OAuthInfo.app_secret, "grant_type" : "authorization_code", "code" : code, "redirect_uri" : OAuthInfo.redirect_uri]
        Alamofire.request(OAuthInfo.Access_tokenURLString, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            finished(response)
        }
    }
    
   


}
