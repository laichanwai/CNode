//
//  CommentCell.swift
//  CNode
//
//  Created by Ivy on 16/5/11.
//  Copyright © 2016年 Ivy. All rights reserved.
//

import UIKit

let WEBVIEW_TOP: CGFloat = 36
class CommentCell: UITableViewCell {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        authorLabel.left = 15
//        authorLabel.top = 15
//        
//        timeLabel.right = MAINSCREEN_SIZE.width - 15
//        timeLabel.top = 15
//        
//        webView.frame = CGRectMake(15, authorLabel.bottom + 5, MAINSCREEN_SIZE.width - 30, 40)
        webView.scrollView.bounces = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.scrollEnabled = false
        webView.opaque = false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
