//
//  TopicDetailViewController.swift
//  CNode
//
//  Created by Ivy on 16/4/27.
//  Copyright © 2016年 Ivy. All rights reserved.
//

import UIKit
import SnapKit
import PKHUD

// MARK: - Life Circle
private let commentLimit = Int.max
class TopicDetailViewController: UIViewController {
    
    var topic: TopicModel! {
        didSet {
            replyHeights.removeAll()
            loadComments()
        }
    }
    var replyHeights: [CGFloat] = []
    @IBOutlet weak var scrollView: TopicScrollView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var loadMoreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加载数据
        TopicStorage.loadTopic(topic.id!) { (topic) in
            self.topic = topic
            self.scrollView.tableView.reloadData()
        }
        scrollView.tableView = tableView
        scrollView.footer = loadMoreButton
        scrollView.setupViews(topic)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(self.topicCommentWebViewDidFinishLoad(_:)),
            name: CommentCellWebViewDidFinishLoad,
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(self.topicContentWebViewDidFinishLoad(_:)),
            name: TopicScrollViewWebViewDidFinishLoad,
            object: nil)
        
        HUD.show(.Progress)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Notification
extension TopicDetailViewController {
    /** (加了 HUD 之后未使用优化)
     性能优化方案
     加载完之后才刷新列表
     */
//    var tempIndexPaths: [NSIndexPath] = []
//    var lastCount = 0
    func topicCommentWebViewDidFinishLoad(noti: NSNotification) {
        if let cell: CommentCell = noti.object as? CommentCell {
            if replyHeights[cell.webView.tag] > 0.0 {
                return
            }
            replyHeights[cell.webView.tag] = cell.webViewHeightConstraint.constant + WEBVIEW_TOP
            let indexPath = NSIndexPath(forRow: cell.webView.tag, inSection: 0)
            scrollView.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            //            tempIndexPaths.append(indexPath)
            //            print("\(tempIndexPaths.count)   \(lastCount)   \(replyHeights.count)  \(self.topic.replyCount)")
            //            if tempIndexPaths.count >= commentLimit || tempIndexPaths.count + lastCount >= replyHeights.count {
            //                scrollView.tableView.reloadRowsAtIndexPaths(tempIndexPaths, withRowAnimation: .None)
            //                scrollView.updateLayout()
            //                lastCount = tempIndexPaths.count
            //                tempIndexPaths.removeAll()
            //            }
        }
    }
    
    func topicContentWebViewDidFinishLoad(noti: NSNotification) {
        print("content load finish")
        
        HUD.hide()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "tableView.contentSize" {
            print("change -> \(change)")
            removeObserver(self, forKeyPath: keyPath!)
        }
    }
}

// MARK: - UITableView DataSource & Delegate
extension TopicDetailViewController : UITableViewDataSource, UITableViewDelegate {
    
    // MARK: TableView DataSource
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
        cell.webView.loadHTMLString(reply.content!, baseURL: "http://".url)
        cell.webView.tag = indexPath.row
        
        return cell
    }
    
    // MARK: TableView Deleagte
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return replyHeights[indexPath.row]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(topic.replies[indexPath.row].content)
    }
}

// MARK: - Event Response
extension TopicDetailViewController {
    
    @IBAction func loadMoreButtonClick(sender: AnyObject) {
        print("load more comments")
        let lastIndex = replyHeights.count
        if !loadComments() {
            loadMoreButton.setTitle("没有更多了", forState: .Normal)
            loadMoreButton.enabled = false
            return
        }
        var indexPaths: [NSIndexPath] = []
        for i in lastIndex..<replyHeights.count {
            indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
        }
        scrollView.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
        scrollView.updateLayout()
    }
}

// MARK: - Private
private extension TopicDetailViewController {
    
    func loadComments() -> Bool {
        if replyHeights.count >= topic.replyCount {
            return false
        }
        let count = replyHeights.count + commentLimit
        for _ in replyHeights.count..<(count > topic.replies.count ? topic.replies.count : count)  {
            replyHeights.append(0.0)
        }
        return true
    }
}
