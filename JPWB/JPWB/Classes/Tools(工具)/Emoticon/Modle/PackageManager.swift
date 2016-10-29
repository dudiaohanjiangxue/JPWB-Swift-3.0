//
//  PackageManager.swift
//  emoticon
//
//  Created by KC on 16/10/28.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class PackageManager {
 
    //MARK: - 属性
    var emoticonPackages: [EmoticonPackage] = [EmoticonPackage]()
    
    init() {
        //1.添加最近的包
        emoticonPackages.append(EmoticonPackage(id: ""))
        //2.添加默认的包
         emoticonPackages.append(EmoticonPackage(id: "com.sina.default"))
        //3.添加emoji及包
         emoticonPackages.append(EmoticonPackage(id: "com.apple.emoji"))
        //4.添加浪小花的包
         emoticonPackages.append(EmoticonPackage(id: "com.sina.lxh"))
        
        
    }
}
