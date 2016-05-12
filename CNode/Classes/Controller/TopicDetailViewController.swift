//
//  TopicDetailViewController.swift
//  CNode
//
//  Created by Ivy on 16/4/27.
//  Copyright © 2016年 Ivy. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class TopicDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WKNavigationDelegate {
    
    var topic: TopicModel!
    var replyHeights: [CGFloat] = []
    @IBOutlet weak var scrollView: TopicScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加载数据
        TopicStorage.loadTopic(topic.id!) { (topic) in
            self.topic = topic
            self.replyHeights.removeAll()
            for reply in self.topic.replies {
                self.replyHeights.append(reply.heightForRow() + 36)
            }
            self.scrollView.tableView.reloadData()
        }
        
        // ScrollView
        scrollView.setupViews(topic)
        
        // - WebView
        scrollView.webView.navigationDelegate = self
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            self.scrollView.webView.loadHTMLString(self.topic.content!, baseURL: "https://cnodejs.org/".url)
        }
        
        // - TableView
        scrollView.tableView.delegate = self
        scrollView.tableView.dataSource = self
        let nib = UINib(nibName: "CommentCell", bundle: nil)
        scrollView.tableView.registerNib(nib, forCellReuseIdentifier: "CommentCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Delegate
    // MARK: --TableView DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replyHeights.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell") as! CommentCell
        let reply = topic.replies[indexPath.row] as Reply
        cell.authorLabel.text = reply.author?.loginname
        cell.timeLabel.text = TimeUtil.fromNow(NSDate.from(string: reply.createAt!))
        cell.contentLabel.attributedText = reply.markdown
        
        cell.selectionStyle = .None
        cell.backgroundColor = LIGHTGRAY_COLOR
        return cell
    }
    
    // MARK: --TableView Deleagte
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return replyHeights[indexPath.row]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(topic.replies[indexPath.row].content)
    }
    
    // MARK: --WKNavigationDelegate
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
//        dispatch_async(dispatch_get_main_queue()) {
            scrollView.webView.height = webView.scrollView.contentSize.height
            scrollView.layoutIfNeeded()
//        }
        print("didFinishNavigation")
    }
}
