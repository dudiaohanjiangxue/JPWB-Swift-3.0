//
//  DateExtension.swift
//  JPWB
//
//  Created by KC on 16/10/19.
//  Copyright © 2016年 KC. All rights reserved.
//

import Foundation

extension Date {

    static func createTimeString(createAtString: String) -> String {
       let fmt = DateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = Locale(identifier: "en")
        guard let createDate = fmt.date(from: createAtString) else {
            return ""
        }
        let nowDate = Date()
        let intervalTime = Int(nowDate.timeIntervalSince(createDate))
        //1.一分钟之内
        if intervalTime < 60 {
            return "刚刚"
        }
        // 7.如果是一小时之内
        if intervalTime < 60 * 60  {
            return "\(intervalTime / 60)分钟前"
        }
        
        // 8.一天之内
        if intervalTime < 60 * 60 * 24 {
            return "\(intervalTime / 60 * 60)小时前"
        }
        // 9.创建日历对象
        let calender = Calendar.current
        // 10.判断是否在昨天
        if calender.isDateInYesterday(createDate) {
           fmt.dateFormat = "HH:mm"
            let timeString = fmt.string(from: createDate)
            return "昨天\(timeString)"
        }
        // 11.判断一年之内
        let comps = NSSet(objects: Calendar.Component.year)
        let cmps = calender.dateComponents(comps as! Set<Calendar.Component>, from: createDate, to: nowDate)
        if  cmps.year! < 1  {
            fmt.dateFormat = "MM-dd HH:mm"
            let timeString = fmt.string(from: createDate)
            return timeString
        }
        // 12.大于一年
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        let timeString = fmt.string(from: createDate)
        return timeString
    }

}
