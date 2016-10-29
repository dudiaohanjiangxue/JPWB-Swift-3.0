//
//  EmoticonPackage.swift
//  emoticon
//
//  Created by KC on 16/10/28.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class EmoticonPackage: NSObject {
    //MARK: - 属性
    var emoticons: [Emoticon] = [Emoticon]()
    init(id: String) {
        super.init()
        if  id == "" {
            addEmptyEmoticon()
            return
        }
        guard let infoPath = Bundle.main.path(forResource:"\(id)/info.plist", ofType: nil, inDirectory: "Emoticon.bundle") else {
            print("路径的原因")
            return
        }
        guard let dictArray = NSArray(contentsOfFile: infoPath) as? [[String: Any]] else {
        print("取不出数据")
        return
        }
        
        var index = 0
        for var dict in dictArray {
            index += 1
            if let png = dict["png"] as? String {
                dict["png"] = "\(id)/" + png
            }
            //字典转模型
            emoticons.append(Emoticon(dict: dict))
            //如果添加表情的个数%20 == 0,添加一个删除按钮
            if index % 20 == 0 {
                emoticons.append(Emoticon(isRemove: true))
            }
        }
        self.addEmptyEmoticon()
        
    }
    
    private func addEmptyEmoticon() {
       //1.求出改组剩余的个数
        let leftCount = emoticons.count % 21
        //2.如果== 0 测没有剩余, 否则要添加够21个
        if  leftCount == 0 && emoticons.count != 0 {
            return
        }
        //3.添加空白的表情
        for _ in leftCount..<20 {
            emoticons.append(Emoticon(isEmpty: true))
        }
        //4.添加删除按钮
        emoticons.append(Emoticon(isRemove: true))
    }
}
