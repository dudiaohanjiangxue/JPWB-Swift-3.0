//
//  FindEmoticonString.swift
//  emoticon
//
//  Created by KC on 16/10/29.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit
class FindEmoticonString {
    //单例
    static  let  shared : FindEmoticonString = FindEmoticonString()
    
    ////MARK: - 懒加载属性
    private lazy var manager : PackageManager = PackageManager()
    
    func findEmoticonString(text: String, fontHeight: CGFloat) -> NSMutableAttributedString? {
    
        //2.创建规则
        let pattern = "\\[.*?\\]"
        //3.创建正则表达式对象
        guard  let  regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        //4.匹配结果
        let results = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.characters.count))
        
        //5.遍历结果
        //5.0根据原有的内容创建可变的属性字符串
        let attMStr = NSMutableAttributedString(string: text)
        for (_, result) in results.reversed().enumerated() {
            let chs = (text as NSString).substring(with: result.range)
            guard let pngPath = findPngPathWithChs(chs: chs) else {
                continue
            }
            let attachment = NSTextAttachment()
            attachment.bounds = CGRect(x: 0, y: -3, width: fontHeight, height: fontHeight)
            attachment.image = UIImage(contentsOfFile: pngPath)
            let resultMStr = NSAttributedString(attachment: attachment)
            attMStr.replaceCharacters(in: result.range, with: resultMStr)
        }
       return attMStr
    
    }
    
    //根据表情字体找到表情的路径
    private func findPngPathWithChs(chs : String) -> String? {
        for package in manager.emoticonPackages {
            for emoticon in package.emoticons {
                if emoticon.chs == chs {
                    return emoticon.pngPath
                }
            }
        }
        
        return nil
    }
    
}
