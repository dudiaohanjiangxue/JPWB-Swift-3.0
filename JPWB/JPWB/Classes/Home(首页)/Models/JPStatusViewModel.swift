//
//  JPStatusViewModel.swift
//  JPWB
//
//  Created by KC on 16/10/19.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class JPStatusViewModel {
   //MARK: - 属性
    var status: JPStatusModal?
    ///来源文本
    var sourceText: String?
    ///创建时间的文本
    var createdAtString: String?  {
        guard let createdAt = status?.created_at else {
            return ""
        }
        return Date.createTimeString(createAtString: createdAt)
    }
    
    ///认证图标
    var verifiedImage: UIImage?
    
    ///会员像是的图标
    var vipImage : UIImage?
    
    ///头像URL
    var iconUrl : URL?
    ///这条微博所有配图的URL
    var picURLs: [URL] = [URL]()
    
    
    init(status: JPStatusModal) {
        self.status = status
        
        //处理文本来源
        guard let source = status.source , status.source != "" else {
            return
        }
        let startIndex = (source as NSString).range(of: ">").location + 1
        let length = (source as NSString).range(of: "</").location - startIndex
        
        sourceText = "来自" + (source as NSString).substring(with: NSRange.init(location: startIndex, length: length))
        
        //处理认证类型图片
        let type = status.user?.verified_type ?? -1
        switch type {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        //处理vip
        let mbrank = status.user?.mbrank ?? 0
        
        if mbrank >= 1 && mbrank <= 6  {
            let vipImageName = "common_icon_membership_level\(mbrank)"
            vipImage = UIImage(named: vipImageName)
        }else {
            
            vipImage = nil
            
        }
        
        //头像URL
        let urlString = status.user?.profile_image_url ?? ""
         iconUrl = URL(string: urlString)
        
        //配图URl处理
        
        let picUrls = status.pic_urls?.count != 0 ? status.pic_urls : status.retweeted_status?.pic_urls
        if let picUrlDicts = picUrls {
            for picURLDict in picUrlDicts {
                let picURLString = picURLDict["thumbnail_pic"] as? String
                let picURL = URL(string: picURLString ?? "")
                picURLs.append(picURL!)
            }
        }
    }
    
    
}
