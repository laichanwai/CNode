//
//  TimeUtil.swift
//  CNode
//
//  Created by Ivy on 16/5/10.
//  Copyright © 2016年 Ivy. All rights reserved.
//

import SwiftDate

class TimeUtil: NSObject {

    static let DATE_FORMATTER = DateFormat.Custom("yyyy-MM-dd HH:mm")
    static let ONE_MINUTE = 60.0
    static let ONE_HOUR = 60 * ONE_MINUTE
    static let ONE_DAY = 24 * ONE_HOUR
    static let ONE_MONTH = 30 * ONE_DAY
    
    class func fromNow(date: NSDate) -> String {
        let passed = abs(date.timeIntervalSinceNow)
        
        if passed > ONE_MONTH {
            return date.toString(DATE_FORMATTER)!
        } else if passed > ONE_DAY {
            return String(Int(passed / ONE_DAY)) + "天前"
        } else if passed > ONE_HOUR {
            return String(Int(passed / ONE_HOUR)) + "小时前"
        } else if passed > ONE_MINUTE {
            return String(Int(passed / ONE_MINUTE)) + "分钟前"
        } else {
            return "刚刚"
        }
    }
}

