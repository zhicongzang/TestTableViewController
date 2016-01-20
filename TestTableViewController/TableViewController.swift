//
//  TableViewController.swift
//  TestTableViewController
//
//  Created by Zhicong Zang on 12/10/15.
//  Copyright © 2015 Zhicong Zang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TableViewController: UITableViewController, pic_CacheDegelate {
    
    var pic_Cache:[String:String] = SupportFunction.checkPicCacheDirectory()
    var img_Cache = [String:CGImage]()
    
    var weibos: [WeiboData] = []
    
    var cellHeightCache:[Int:CGFloat] = [:]
    var token = ""
    
    var needLoadArr = [NSIndexPath]()
    
    let cell:UITableViewCell = UITableViewCell()
    
    let cellHeightQueue = dispatch_queue_create("cellHeight", DISPATCH_QUEUE_CONCURRENT)
    let saveImageQueue = dispatch_queue_create("saveImage", DISPATCH_QUEUE_CONCURRENT)
    let needLoadQueue = dispatch_queue_create("needLoad", DISPATCH_QUEUE_CONCURRENT)
    
    var totalCellHeight:CGFloat = 0
    
    override func viewDidLoad() {
        
        
        
      /*  Weibo.getWeibo().authorizeWithCompleted { (account, error) -> Void in
            if error == nil {
                print("Token: \(account.accessToken)")
                self.token = account.accessToken
                self.loadData()
            }else {
                print("Fail")
            }
        }*/
        
        loadData()
        
        super.viewDidLoad()
        
        tableView.separatorStyle = .None
        
        
        let cellNib = UINib(nibName: "WeiboCell", bundle: nil)
        self.tableView.registerNib(cellNib, forCellReuseIdentifier: "Weibo")
        
        let textCellNib = UINib(nibName: "PWeiboCell", bundle: nil)
        self.tableView.registerNib(textCellNib, forCellReuseIdentifier: "P")
        
    
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return weibos.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == weibos.count - 5 {
            loadData()
        }
        
        let data = weibos[indexPath.row]
        
        
    
        
        if needLoadArr.count > 0 && needLoadArr.indexOf(indexPath) == nil{
            return self.cell
        }
       // let cell = tableView.dequeueReusableCellWithIdentifier("Weibo", forIndexPath: indexPath) as! WeiboCell
       // cell.setWeiboData(weibos[indexPath.row], pic_Cache: pic_Cache, delegate: self)
        
        let cell = tableView.dequeueReusableCellWithIdentifier("P", forIndexPath: indexPath) as! PWeiboCell
        cell.context = data.text
        cell.userName = data.user.name
        cell.drawCell(data, pic_Cache: pic_Cache, delegate: self, saveImageQueue: saveImageQueue,img_Cache: img_Cache)
        
        
        
        return cell
        
    }
    
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let data = weibos[indexPath.row]
        if let height = cellHeightCache[data.id] {
            return height
        }else {
            if data.smallPicUrl != "" {
                let height = WeiboCell.cellHeightByData(data) + 150 + 8
                cellHeightCache[data.id] = height
                return height
            }else {
                let height = WeiboCell.cellHeightByData(data)
                cellHeightCache[data.id] = height
                return height
            }
        }
        
        

    }
    
    
    
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            if let iP = self.tableView.indexPathForRowAtPoint(CGPointMake(0, targetContentOffset.memory.y)) {
                let cIP = (self.tableView.indexPathsForVisibleRows?.first)!
                let skipCount = 8
                if labs((cIP.row) - (iP.row)) > skipCount && velocity.y > 0{
                    self.needLoadArr.removeAll()
                    let temp = self.tableView.indexPathsForRowsInRect(CGRectMake(0, targetContentOffset.memory.y, self.tableView.frame.width, self.tableView.frame.height))!
                    let indexPath = temp.last
                    self.needLoadArr.append(NSIndexPath(forRow: (indexPath?.row)! - 3, inSection: 0))
                    self.needLoadArr.append(NSIndexPath(forRow: (indexPath?.row)! - 2, inSection: 0))
                    self.needLoadArr.append(NSIndexPath(forRow: (indexPath?.row)! - 1, inSection: 0))
                    self.needLoadArr.append(NSIndexPath(forRow: (indexPath?.row)! , inSection: 0))
                    
    
                    
                }else {
                    self.needLoadArr.removeAll()
                    
                }
            }
        
    }

    
    
    
    func loadData(){
        Alamofire.request(.GET, "https://api.weibo.com/2/statuses/public_timeline.json?access_token=2.00kK7JSG0IVHcF73dc2cde89OU4MQC").responseJSON { (response) -> Void in
            switch response.result{
            case .Success:
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    if let value = response.result.value {
                        let json = JSON(value)
                        for(_,subJson):(String,JSON) in json["statuses"]{
                            let weibo = WeiboData(data: subJson)
                            self.weibos.append(weibo)
                            self.calculateCellHeight(weibo)
                            //  NetworkRequest.downloadPicFromWeiboData(weibo, cache: self.pic_Cache, delegate: self, saveImageQueue: self.saveImageQueue)
                        }
                    }
                //    self.tableView.estimatedRowHeight = self.totalCellHeight / CGFloat(self.weibos.count)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                })
                
                
                
            case .Failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func calculateCellHeight(data:WeiboData){
        dispatch_async(cellHeightQueue) { () -> Void in
            if self.cellHeightCache[data.id] == nil {
                if data.smallPicUrl != "" {
                    let height = WeiboCell.cellHeightByData(data) + 150 + 8
                    self.cellHeightCache[data.id] = height
                    self.totalCellHeight = self.totalCellHeight + height
                }else {
                    let height = WeiboCell.cellHeightByData(data)
                    self.cellHeightCache[data.id] = height
                    self.totalCellHeight = self.totalCellHeight + height
                }
            }
        }
    }
    
    
    
    func appendPic_Cache(key: String, value: String) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.pic_Cache[key] = value
            let savePath = NSHomeDirectory() + "/Documents/Pic_Cache/pic_Cache.plist"
            let tmp = self.pic_Cache as NSDictionary
            tmp.writeToFile(savePath, atomically: true)
        }
        
    }
    
    func appendImg_Cache(key: String, value: CGImage) {
        self.img_Cache[key] = value
    }
    
    


}
