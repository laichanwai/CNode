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
class TopicDetailViewController: UIViewController {
    
    var topic: TopicModel! {
        didSet {
            replyHeights.removeAll()
            for _ in 0 ..< topic.replies.count {
                replyHeights.append(0.0)
            }
        }
    }
    var replyHeights: [CGFloat] = []
    @IBOutlet weak var scrollView: TopicScrollView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加载数据
        TopicStorage.loadTopic(topic.id!) { (topic) in
            self.topic = topic
            self.scrollView.tableView.reloadData()
        }
        scrollView.tableView = tableView
        scrollView.setupViews(topic)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hideNavigationBar()
        
        addNotification(TopicScrollViewWebViewDidFinishLoad, selector: #selector(self.topicContentWebViewDidFinishLoad(_:)))
        addNotification(CommentCellWebViewDidFinishLoad, selector: #selector(self.topicCommentWebViewDidFinishLoad(_:)))
        
        HUD.show(.Progress)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        navigationController?.showNavigationBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Notification
var tempIndexPaths: [NSIndexPath] = []
extension TopicDetailViewController {
    
    func topicCommentWebViewDidFinishLoad(noti: NSNotification) {
        if let cell: CommentCell = noti.object as? CommentCell {
            if replyHeights[cell.webView.tag] > 0.0 {
                return
            }
            replyHeights[cell.webView.tag] = cell.webViewHeightConstraint.constant + WEBVIEW_TOP
            let indexPath = NSIndexPath(forRow: cell.webView.tag, inSection: 0)
            tempIndexPaths.append(indexPath)
            print("row : \(cell.webView.tag)  count : \(tempIndexPaths.count) total : \(replyHeights.count)")
            if tempIndexPaths.count == replyHeights.count || tempIndexPaths.count % 5 == 0 {
                scrollView.tableView.reloadRowsAtIndexPaths(tempIndexPaths, withRowAnimation: .None)
                scrollView.updateLayout()
            }
        }
    }
    
    /** (加了 HUD 之后未使用优化)
        内容加载完之后才可以浏览
     */
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

}

// MARK: - Private
private extension TopicDetailViewController {
    
}
