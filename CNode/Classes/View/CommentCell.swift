//
//  CommentCell.swift
//  CNode
//
//  Created by Ivy on 16/5/11.
//  Copyright © 2016年 Ivy. All rights reserved.
//

import UIKit

let CommentCellWebViewDidFinishLoad = "CommentCellWebViewDidFinishLoad"
let WEBVIEW_TOP: CGFloat = 36
class CommentCell: UITableViewCell, UIWebViewDelegate {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        webView.scrollView.bounces = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.scrollEnabled = false
        webView.opaque = false
        
        selectionStyle = .None
        backgroundColor = LIGHTGRAY_COLOR
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        let height = CGFloat(Double(webView.stringByEvaluatingJavaScriptFromString("document.body.scrollHeight")!)!)
        webViewHeightConstraint.constant = height
        NSNotificationCenter.defaultCenter().postNotificationName(CommentCellWebViewDidFinishLoad, object: self)
    }
}
