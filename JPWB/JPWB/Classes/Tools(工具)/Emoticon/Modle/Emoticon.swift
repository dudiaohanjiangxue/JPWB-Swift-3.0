//
//  Emoticon.swift
//  emoticon
//
//  Created by KC on 16/10/28.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class Emoticon: NSObject {
   //MARK: - 属性
    ///emoji对应的code
    var code : String? {
        didSet{
            guard let code = code else {
                return
            }
            // 1.创建扫描器
            let scanner = Scanner(string: code)
            // 2.扫描字符串中的内容,并且获取扫描结果
            var value: UInt32 = 0
            scanner.scanHexInt32(&value)
            // 3.将value转成字符
            let c = Character(UnicodeScalar(value)!)
            // 4.将字符转成字符串
            emojiCode = String(c)
        
        }
    
    }
    ///表情对应的文字
    var chs : String?
    ///表情对应的图片名字
    var png : String? {
        didSet{
            guard let png = png else {
                return
            }
           pngPath = Bundle.main.bundlePath + "/Emoticon.bundle/" + png
        }
    
    }
    
    /**emoji对应的code*/
    var emojiCode : String?
    /**表情对应的图片路径*/
    var pngPath : String?
    
    ///标志改Emoticon是否是一个删除按钮
    var isRemove: Bool = false
    /// 标志该Emoticon是否是一个空白按钮
    var isEmpty: Bool = false
    
    init(isEmpty: Bool) {
        self.isEmpty = isEmpty
    }
    
    init(isRemove: Bool) {
        self.isRemove = isRemove
    }
    
    init(dict: [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
    
     return dictionaryWithValues(forKeys: ["emojiCode","chs","pngPath"]).description
    }
}
