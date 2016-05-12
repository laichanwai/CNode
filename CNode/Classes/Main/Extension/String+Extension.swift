//
//  String+Extension.swift
//  CNode
//
//  Created by Ivy on 16/5/11.
//  Copyright © 2016年 Ivy. All rights reserved.
//

import Foundation
import UIKit
import SwiftyDown

extension String {
    
    var url: NSURL! {
        get {
            return NSURL(string: self)
        }
    }
    
//    var htmlToString: String {
//        return NSAttributedString(
//            data: dataUsingEncoding(NSUTF8StringEncoding)!,
//            options: [
//                NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
//                NSCharacterEncodingDocumentAttribute : NSUTF8StringEncoding
//            ],
//            documentAttributes: nil,
//            error: nil)!.string
//    }
//    var htmlToNSAttributedString: NSAttributedString {
//        return NSAttributedString(
//            data: dataUsingEncoding(NSUTF8StringEncoding)!,
//            options: [
//                NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
//                NSCharacterEncodingDocumentAttribute : NSUTF8StringEncoding
//            ],
//            documentAttributes: nil,
//            error: nil)!
//    }
    
    var markDown2AttributedString: NSAttributedString {
        
        let md = MarkdownParser()
        return md.convert(self)
    }
}