//
//  TopicDetailViewController.swift
//  CNode
//
//  Created by Ivy on 16/4/27.
//  Copyright © 2016年 Ivy. All rights reserved.
//

import UIKit
import SnapKit

private let commentLimit = 50
class TopicDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate {
    
    var topic: TopicModel! {
        didSet {
            replyHeights.removeAll()
            self.showComments()
        }
    }
    var replyHeights: [CGFloat] = []
    @IBOutlet weak var scrollView: TopicScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加载数据
        TopicStorage.loadTopic(topic.id!) { (topic) in
            self.topic = topic
            self.scrollView.tableView.reloadData()
        }
        
        scrollView.setupViews(topic)
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
        cell.selectionStyle = .None
        let reply = topic.replies[indexPath.row] as Reply
        
        cell.authorLabel.text = reply.author?.loginname
        
        cell.timeLabel.text = TimeUtil.fromNow(NSDate.from(string: reply.createAt!))
        
        cell.webView.loadHTMLString(reply.content!, baseURL: "http://".url)
        cell.webView.tag = indexPath.row
        cell.webView.delegate = self
        
        return cell
    }
    
    // MARK: --TableView Deleagte
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return replyHeights[indexPath.row]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(topic.replies[indexPath.row].content)
    }
    
    // MARK: --UIWebView Delegate
    func webViewDidFinishLoad(webView: UIWebView) {
        if replyHeights[webView.tag] > 0.0 {
            return
        }
        let height = CGFloat(Double(webView.stringByEvaluatingJavaScriptFromString("document.body.scrollHeight")!)!)
        replyHeights[webView.tag] = height + WEBVIEW_TOP
        scrollView.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: webView.tag, inSection: 0)], withRowAnimation: .Automatic)
        scrollView.layoutIfNeeded()
    }
    
    // MARK: - Private
    func showComments() {
        let count = replyHeights.count + commentLimit
        for _ in replyHeights.count..<(count >= topic.replies.count ? topic.replies.count : count)  {
            replyHeights.append(0.0)
        }
    }
}
