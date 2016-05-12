//
//  TopicStorage.swift
//  CNode
//
//  Created by Ivy on 16/5/9.
//  Copyright © 2016年 Ivy. All rights reserved.
//

import Alamofire
import SwiftyJSON

let TABS_KEYS = ["all","share","ask","job"]
let TABS_VALUE = ["全部","分享","问答","招聘"]
let TABS_DIC = [
    "all"   : "全部",
    "share" : "分享",
    "ask"   : "问答",
    "job"   : "招聘"
]

enum TopicTab: Int {
    case All    = 0
    case Share  = 1
    case Ask    = 2
    case Job    = 3
}

private let _instance = TopicStorage()
class TopicStorage: NSObject {
    
    var currentPage = [1,1,1,1]
    
    class var shareStorage: TopicStorage {
        return _instance
    }
    
    class func loadTopics(tab: TopicTab, refresh: Bool, finish:(topics: [TopicModel]?)->()) {
        TopicStorage.shareStorage.loadTopics(tab, refresh: refresh, finish: finish)
    }
    
    class func loadTopic(topicID: String, finish: (TopicModel?) -> ()) {
        TopicStorage.shareStorage.loadTopic(topicID, finish: finish)
    }
    
    func loadTopics(tab: TopicTab, refresh: Bool, finish:(topics: [TopicModel]?)->()) {
        currentPage[tab.rawValue] = refresh ? 1 : currentPage[tab.rawValue] + 1
        
        let url = "https://cnodejs.org/api/v1/topics?page=\(currentPage[tab.rawValue])&tab=\(TABS_KEYS[tab.rawValue])"
        
        Alamofire.request(.GET, url).responseSwiftyJSON({ (_, _, json, _) in
            var topics: [TopicModel] = []
            let data = json["data"]
            for (_, topicJSON): (String, JSON) in data {
                let topic = TopicModel(json: topicJSON)
                topics.append(topic)
            }
            finish(topics: topics)
        })
    }
    
    func loadTopic(topicID: String, finish: (TopicModel?) -> ()) {
        let url = "https://cnodejs.org/api/v1/topic/\(topicID)"
        
        Alamofire.request(.GET, url, parameters: ["mdrender" : "false"]).responseSwiftyJSON( { (_, _, json, _) in
            let data = json["data"]
            let topic = TopicModel(json: data)
            finish(topic)
        })
    }
}