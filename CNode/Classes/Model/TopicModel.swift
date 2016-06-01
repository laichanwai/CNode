//
//  TopicModel.swift
//  CNode
//
//  Created by Ivy on 16/4/27.
//  Copyright © 2016年 Ivy. All rights reserved.
//

import Foundation
import SwiftyJSON

class Author: NSObject {
    var avatarUrl: String?
    var loginname: String?
}

class Reply: NSObject {
    var id: String?
    var author: Author?
    var content: String?
    var ups: [String]?
    var createAt: String?
}

class TopicModel: NSObject {
    var id: String?
    var authorId: String?
    var tab: String?
    var content: String?
    var title: String?
    var createAt: String?
    var lastTime: String?
    var isGood: Bool?
    var isTop: Bool?
    var author: Author?
    var replies: [Reply] = []
    var replyCount: Int?
}

extension Author {
    convenience init(json: JSON) {
        self.init()
        
        loginname  = json["loginname"].string
        if let url = json["avatar_url"].string {
            avatarUrl = url.hasPrefix("//") ? "http:" + url : url
        }
    }
}

extension Reply {
    convenience init(json: JSON) {
        self.init()
        
        id       = json["id"].string
        content  = TopicModel.htmlWrapContent(json["content"].string!)
//        content = json["content"].string
        ups      = json["ups"].arrayObject as? [String]
        createAt = TopicModel.timeFromString(json["create_at"].string!)
        author   = Author(json: json["author"])
    }
}

extension TopicModel {
    convenience init(json: JSON) {
        self.init()
        
        id         = json["id"].string
        authorId   = json["author_id"].string
        tab        = json["tab"].string
        content    = TopicModel.htmlWrapContent(json["content"].string!)
        title      = json["title"].string
        createAt   = TopicModel.timeFromString(json["create_at"].string!)
        lastTime   = TopicModel.timeFromString(json["last_reply_at"].string!)
        isGood     = json["good"].bool
        isTop      = json["top"].bool
        author     = Author(json: json["author"])
        replyCount = json["reply_count"].int
        for (_, replyJSON): (String, JSON) in json["replies"] {
            replies.append(Reply(json: replyJSON))
        }
    }
    
    class func timeFromString(timeString: String) -> String {
        let date = timeString.substringWithRange(timeString.startIndex..<timeString.startIndex.advancedBy(10))
        let time = timeString.substringWithRange(timeString.startIndex.advancedBy(11)..<timeString.startIndex.advancedBy(16))
        
        return date + " " + time
    }
    
    class func htmlWrapContent(content: String) -> String {
        
        
        let html = "<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"initial-scale=1, user-scalable=no, width=device-width\" /><style>html, body, div, p, img {width: 100%;word-break: break-all;word-wrap: break-word;} html, body { margin: 0; }</style></head><body>" + content + "</body></html>"
        return html
            .stringByReplacingOccurrencesOfString("\n", withString: "")
            .stringByReplacingOccurrencesOfString("<p>", withString: "")
            .stringByReplacingOccurrencesOfString("</p>", withString: "")
            .stringByReplacingOccurrencesOfString("<br /></div>", withString: "</div>")
    }
}


