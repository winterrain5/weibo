//
//  NSDate+Extension.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/9/9.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

extension NSDate {
    
    // 类方法 加 class
    class func createDate(timeStr :String,formaterStr:String) -> NSDate{
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = formaterStr
        // 如果不指定 真机中可能无法转化
        formatter.locale = NSLocale(localeIdentifier: "en")
        return formatter.dateFromString(timeStr)!

    }
    
    // 对象方法
    // 生成当前时间对应 的字符串
    func descriptionStr() -> String {
        
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en")

        // 创建日历
        let calendar = NSCalendar.currentCalendar()
        
        var formaterStr = "HH:mm"
        if calendar.isDateInToday(self) { // 今天
            
            // 比较
            let interval = Int (NSDate().timeIntervalSinceDate(self))
            
            if interval < 60 { // 刚刚
                
                return  "刚刚"
                
            } else if interval < 60 * 60 { // 几分钟前
                
                return "\(interval / 60)分钟前"
                
            } else if interval < 60 * 60 * 24 { // 几小时前
                
                return "\(interval / (60 * 60))小时前"
                
            }
            
        } else if calendar.isDateInYesterday(self){ // 昨天
            formaterStr = "昨天" + formaterStr
            
        } else {
            
            // 两个时间相差多长时间
            let comps = calendar.components(NSCalendarUnit.Year, fromDate: self, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
            
            if comps.year >= 1  { // 更早时间
                
                formaterStr = "yyyy-MM-dd" + formaterStr
                
            } else { // 一年以内
                
                formaterStr = "MM-dd" + formaterStr
                
            }
            
        }
        formatter.dateFormat = formaterStr
        return  formatter.stringFromDate(self)
    }
}
