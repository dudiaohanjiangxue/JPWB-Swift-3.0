//
//  JPConst.swift
//  JPWB
//
//  Created by KC on 16/10/14.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

struct OAuthInfo {
    static let app_key = "1780671795"
    static let app_secret = "aed1011cad059a08b2ec2919cfb82af5"
    static let redirect_uri = "http://www.520it.com"
   
}

//MARK: - 接口
struct JPRequestURLString {
    /**获取access_token*/
    static let access_token = "https://api.weibo.com/oauth2/access_token"
    /**获取用户信息*/
    static let userInfo = "https://api.weibo.com/2/users/show.json"
    /**获取用户的微博*/
    static let userStatuses = "https://api.weibo.com/2/statuses/home_timeline.json"
    /**发布文字微博*/
    static let composeTextStatus = "https://api.weibo.com/2/statuses/update.json"
    /**发布图片微博*/
    static let composeImageStatus = "https://api.weibo.com/2/statuses/upload.json"
    
}

struct JPHomeConst {
    
    static let edgeMargin: CGFloat = 15
    static let pading: CGFloat = 10

}


struct PhotoBrowserVcNote {
    //通知的名字
     static let name = "showPhotoBrowserVcNote"
    ///通知点击图片的序号
     static let showPhotoBrowserVcNoteIndex = "showPhotoBrowserVcNoteIndex"
    /**通知该条微博图片的所有urls*/
     static let showPhotoBrowserVcNotePicURLs = "showPhotoBrowserVcNotePicURLs"
}
