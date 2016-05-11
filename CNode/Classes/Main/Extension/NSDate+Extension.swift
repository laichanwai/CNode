//
//  NSDate+Extension.swift
//  CNode
//
//  Created by Ivy on 16/5/10.
//  Copyright © 2016年 Ivy. All rights reserved.
//

import SwiftDate

extension NSDate {
    
    class func formatter() -> NSDateFormatter {
        let formatter = NSDateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }
    
    class func from(string dateString: String) -> NSDate {
        return formatter().dateFromString(dateString)!
    }
    
    class func toString(date date: NSDate) -> String {
        return formatter().stringFromDate(date)
    }
}