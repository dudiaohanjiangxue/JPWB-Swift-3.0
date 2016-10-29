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
//            print(dataRespose.result.value)
            print(dataRespose.timeline)
            
            finished(dataRespose.result.value, dataRespose.result.isSuccess)
        }
    }
}

//MARK: - 获取微博和用户的信息
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
    
    ///获取用户的微博数据
    func requestUserStatuses(since_id: Int, max_id: Int, finished: @escaping finisedCallBack) {
        guard  let accecc_token = JPuserAccountViewModel.shared.account?.access_token else {
            return
        }
        let params = ["access_token": accecc_token, "since_id" : since_id, "max_id" : max_id] as [String : Any]
        request(JPRequestURLString.userStatuses, method: .get, parameters: params) { (response, isSuccess) in
            finished(response, isSuccess)
        }
    }


}


//MARK: - 发布微博
extension JPHTTPRequestTool {
     ///发布文字微博
    func requestToComposeTextStatus(text: String, finished: @escaping finisedCallBack) {
        guard  let access_token = JPuserAccountViewModel.shared.account?.access_token else {
            return
        }
        let params = ["access_token": access_token, "status" : text]
        request(JPRequestURLString.composeTextStatus, method: .post, parameters: params) { (response, isSuccess) in
            finished(response, isSuccess)
        }
    }
    
    ///发布图片微博
    func requestToComposeImageStatus(pic: UIImage, text: String, finished: @escaping finisedCallBack) {
        guard  let access_token = JPuserAccountViewModel.shared.account?.access_token else {
            return
        }
        
        let params = ["access_token": access_token, "status" : text]
        
        
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            for (key, value) in params {
            MultipartFormData.append(value.data(using: .utf8)!, withName: key)
            
            }
            if let imageData = UIImageJPEGRepresentation(pic, 0.2) {
                
//                MultipartFormData.append(imageData, withName: "pic", mimeType: "image/png") 这个方法不行
                MultipartFormData.append(imageData, withName: "pic", fileName: "123.png", mimeType: "image/png")
            }
            }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: JPRequestURLString.composeImageStatus, method: .post, headers: nil) { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON(completionHandler: { (dataRespose) in
                        print(dataRespose.request)
                        print(dataRespose.response)
                        print(dataRespose.result)
                        print(dataRespose.result.value)
                        print(dataRespose.timeline)
                        finished(dataRespose.result.value, dataRespose.result.isSuccess)
                    })
                    
                case .failure(_):
                    JPPrint("转码失败")
                    finished(nil, false)
                }
        }
        
        
    }

}
