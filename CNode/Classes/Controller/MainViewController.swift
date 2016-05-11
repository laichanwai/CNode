//
//  MainViewController.swift
//  CNode
//
//  Created by Ivy on 16/4/27.
//  Copyright © 2016年 Ivy. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import DGElasticPullToRefresh

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Property
    @IBOutlet weak var tableView: UITableView!
    
    let segment = BetterSegmentedControl(
        frame: CGRect(x: 0, y: 64, width: 375, height: 44),
        titles: TABS_VALUE,
        index: 0,
        backgroundColor: LIGHTGRAY_COLOR,
        titleColor: DRAKGRAY_COLOR,
        indicatorViewBackgroundColor: UIColor.clearColor(),
        selectedTitleColor: GREEN_COLOR)

    var topics = [[TopicModel](), [TopicModel](), [TopicModel](), [TopicModel]()]
    var currentIndex = 0
    var refreshing = false
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "主页"
        
        // SegmentControl
        segment.addTarget(self, action: #selector(MainViewController.segmentValueChange(_:)), forControlEvents: .ValueChanged)
        self.view.addSubview(segment)

        // 下拉刷新
        let loadView = DGElasticPullToRefreshLoadingViewCircle()
        loadView.tintColor = GREEN_COLOR
        self.tableView.dg_addPullToRefreshWithActionHandler({
            self.loadTopics(refresh: true)
        }, loadingView: loadView)
        self.tableView.dg_setPullToRefreshFillColor(BLACK_COLOR)
        
        // 加载数据
        self.loadTopics(refresh: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        tableView.dg_removePullToRefresh()
    }
    
    // MARK: - Delegate
    // MARK: --TableView DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics[currentIndex].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TopicCell") as! TopicCell
        let topic: TopicModel = self.topic(at: indexPath)
        
        cell.titleLabel.text = topic.title
        cell.authorLabel.text = topic.author?.loginname
        cell.timeLabel.text = TimeUtil.fromNow(NSDate.from(string: topic.lastTime!))
        
        var tab = "其他"
        cell.tabLabel.textColor = DRAKGRAY_COLOR
        cell.tabLabel.backgroundColor = LIGHTGRAY_COLOR
        if let key = topic.tab {
            tab = TABS_DIC[key]!
            if let isTop = topic.isTop where isTop {
                tab = "顶置"
                cell.tabLabel.textColor = UIColor.whiteColor()
                cell.tabLabel.backgroundColor = GREEN_COLOR
            }else if let isGood = topic.isGood where isGood {
                tab = "精华"
                cell.tabLabel.textColor = UIColor.whiteColor()
                cell.tabLabel.backgroundColor = GREEN_COLOR
            }
        }
        cell.tabLabel.text = tab
        
        return cell
    }
    
    // MARK: --TableView Delegate
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // 加载更多
        if self.topics[currentIndex].count - indexPath.row < 3 {
            loadTopics(refresh: false)
        }
    }
    
    // MARK: - Event Response
    // MARK: --切换分类
    func segmentValueChange(sender: BetterSegmentedControl) {
        self.currentIndex = Int(sender.index)
        
        if self.topics[currentIndex].count == 0 {
            self.loadTopics(refresh: true)
        }
        self.tableView.reloadData()
    }
    
    // MARK: --跳转
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let topicDetailVC = segue.destinationViewController as! TopicDetailViewController
        let indexPath = tableView.indexPathForSelectedRow
        topicDetailVC.topic = topic(at: indexPath!)
    }
    
    // MARK: - Private
    func loadTopics(refresh refresh: Bool) {
        
        if self.refreshing {
            return
        }
        self.refreshing = true
        let tab = TopicTab(rawValue: self.currentIndex)
        TopicStorage.loadTopics(tab!, refresh: refresh) { (topics) in
            if refresh {
                self.topics[self.currentIndex] = topics!
            }else {
                self.topics[self.currentIndex].appendContentsOf(topics!)
            }
            self.refreshing = false
            self.tableView.dg_stopLoading()
            self.tableView.reloadData()
        }
    }
    
    func topic(at indexPath: NSIndexPath) -> TopicModel {
        return self.topics[currentIndex][indexPath.row]
    }
}

// MARK: - fix DGElasticPullToRefresh issue
extension UIScrollView {
    func dg_stopScrollingAnimation() {}
}
