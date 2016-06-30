//
//  TopicScrollView.swift
//  CNode
//
//  Created by Ivy on 16/5/11.
//  Copyright © 2016年 Ivy. All rights reserved.
//

import UIKit
import Kingfisher

let TopicScrollViewWebViewDidFinishLoad = "TopicScrollViewWebViewDidFinishLoad"
private let MARGING: CGFloat = 15.0
private let PADDING: CGFloat = 10.0
private let WIDTH: CGFloat = MAINSCREEN_SIZE.width - 2 * MARGING
class TopicScrollView: UIScrollView, UIWebViewDelegate {
    
    var titleLabel: UILabel!
    var avatarView: UIImageView!
    var authorLabel: UILabel!
    var timeLabel: UILabel!
    var webView: UIWebView!
    var tableView: UITableView!

    func updateLayout() {
        
        tableView.top = webView.bottom
        tableView.height = tableView.contentSize.height
        print("height : \(tableView.height)  contentSize: \(tableView.contentSize)")
        contentSize = CGSizeMake(width, tableView.bottom)
        layoutIfNeeded()
    }
    
    // MARK: Private
    func setupViews(topic: TopicModel) {
        titleLabel = UILabel(frame: CGRectMake(MARGING, MARGING / 2, WIDTH, 0))
        titleLabel.text = topic.title
        titleLabel.textColor = BLACK_COLOR
        titleLabel.font = UIFont.boldSystemFontOfSize(20)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .ByWordWrapping
        titleLabel.sizeToFit()
        addSubview(titleLabel)
        
        avatarView = UIImageView(frame: CGRectMake(MARGING, titleLabel.bottom + PADDING, 30, 30))
        avatarView.kf_setImageWithURL((topic.author?.avatarUrl?.url)!)
        addSubview(avatarView)
        
        authorLabel = UILabel(frame: CGRectMake(avatarView.right + PADDING, 0, WIDTH / 3, 30))
        authorLabel.bottom = avatarView.bottom
        authorLabel.text = topic.author?.loginname
        authorLabel.font = UIFont.systemFontOfSize(17)
        addSubview(authorLabel)
        
        timeLabel = UILabel(frame: CGRectMake(0, authorLabel.top, 150, 30))
        timeLabel.right = WIDTH
        timeLabel.text = topic.createAt
        timeLabel.font = UIFont.systemFontOfSize(15)
        timeLabel.textAlignment = .Right
        timeLabel.textColor = DRAKGRAY_COLOR
        addSubview(timeLabel)
        
        webView = UIWebView(frame: CGRectMake(MARGING, avatarView.bottom + PADDING, WIDTH, MAINSCREEN_SIZE.height))
        webView.loadHTMLString(topic.content!, baseURL: "http://".url)
        webView.delegate = self
        webView.scrollView.bounces = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.scrollEnabled = false
        addSubview(webView)
        
        tableView.frame = CGRectMake(0, webView.bottom + MARGING, width, 100)
        tableView.backgroundColor = LIGHTGRAY_COLOR
        tableView.tableFooterView = UIView()
        addSubview(tableView)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
    
        webView.height = webView.scrollView.contentSize.height
        updateLayout()
        NSNotificationCenter.defaultCenter().postNotificationName(TopicScrollViewWebViewDidFinishLoad, object: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touch")
    }
}
