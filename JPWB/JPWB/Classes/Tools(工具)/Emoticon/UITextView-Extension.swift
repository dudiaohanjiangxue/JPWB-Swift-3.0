//
//  UITextView-Extension.swift
//  emoticon
//
//  Created by KC on 16/10/28.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

extension UITextView {
    ///把表情转化为字符串(然后发送到服务器)
    func  getEmoticonString() -> String {
        // 1.根据customTextView中的属性字符串创建一个可变的属性字符串
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        let range = NSRange(location: 0, length: attrMStr.length)
        attrMStr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            if let attachment = dict["NSAttachment"] as? EmoticonAttachment , (attachment.chs != nil) {
            
            attrMStr.replaceCharacters(in: range, with: attachment.chs!)
            }
        }
        return attrMStr.string
    }
   
    func insertEmoticon(emoticon: Emoticon) {
        //1.判断是否为空的表情
        if emoticon.isEmpty {
            return
        }
        //2.判断是否为删除按钮
        if emoticon.isRemove {
            deleteBackward()
            return
        }
        
        //3.emoji表情
        if emoticon.emojiCode != nil {
            let range = selectedTextRange!
            replace(range, withText: emoticon.emojiCode!)
            return
        }
        
        //4.普通表情
        
        let tempFont = font!
        let range = selectedRange
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        
        let attachment = EmoticonAttachment()
        attachment.chs = emoticon.chs
        attachment.bounds = CGRect(x: 0, y: -3, width: tempFont.lineHeight, height: tempFont.lineHeight)
        attachment.image = UIImage(contentsOfFile: emoticon.pngPath!)
        let imageAttrStr = NSAttributedString(attachment: attachment)
        attrMStr.replaceCharacters(in: range, with: imageAttrStr)
        
        attributedText = attrMStr
        selectedRange = NSRange(location: range.location + 1, length: 0)
        font = tempFont
        
        
    }


}
