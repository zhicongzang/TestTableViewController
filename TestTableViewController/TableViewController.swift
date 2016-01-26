//
//  TableViewController.swift
//  TestTableViewController
//
//  Created by Zhicong Zang on 12/10/15.
//  Copyright © 2015 Zhicong Zang. All rights reserved.
//

import UIKit
import SwiftyJSON


let cellHeightQueue = dispatch_queue_create("cellHeight", DISPATCH_QUEUE_CONCURRENT)
let saveImageQueue = dispatch_queue_create("saveImage", DISPATCH_QUEUE_CONCURRENT)
let writeToLocalQueue = dispatch_queue_create("writeToLocal", DISPATCH_QUEUE_SERIAL)
let createNewImageQueue = dispatch_queue_create("createNewImage", DISPATCH_QUEUE_CONCURRENT)
let downloadPicQueue = dispatch_queue_create("downloadPic", DISPATCH_QUEUE_CONCURRENT)
let requestDownloadPicQueue = dispatch_queue_create("requestDownloadPic", DISPATCH_QUEUE_CONCURRENT)


class TableViewController: UITableViewController, pic_CacheDegelate {
    
    var pic_Cache:[Int:String] = SupportFunction.checkPicCacheDirectory()
    var img_Cache = [String:CGImage]()
    var fullImg_Cache = [Int:CGImage]()
    
    var weibos: [WeiboData] = []
    
    //var token = ""
    
    var needLoadArr = [NSIndexPath]()
    
    let cell:UITableViewCell = UITableViewCell()
    
    
    
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
        
        
        super.viewDidLoad()
        
        tableView.separatorStyle = .None
        
        
        let cellNib = UINib(nibName: "WeiboCell", bundle: nil)
        self.tableView.registerNib(cellNib, forCellReuseIdentifier: "Weibo")
        
        let textCellNib = UINib(nibName: "PWeiboCell", bundle: nil)
        self.tableView.registerNib(textCellNib, forCellReuseIdentifier: "P")
        
        
        loadData()
        sleep(4)
        
        
        
        
        
        
        
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
        if indexPath.row == weibos.count - 15 {
            loadData()
        }
        
        let data = weibos[indexPath.row]
        
        
        
        
        if needLoadArr.count > 0 && needLoadArr.indexOf(indexPath) == nil{
            return self.cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("P", forIndexPath: indexPath) as! PWeiboCell
        cell.getData(data, delegate: self)
        cell.row = indexPath.row
        
        
        return cell
        
    }
    
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let data = weibos[indexPath.row]
        return data.getHeight()
    }
    
    
    
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let iP = self.tableView.indexPathForRowAtPoint(CGPointMake(0, targetContentOffset.memory.y)) {
            let cIP = (self.tableView.indexPathsForVisibleRows?.first)!
            let skipCount = 8
            if labs((cIP.row) - (iP.row)) > skipCount {
                self.needLoadArr.removeAll()
                let temp = self.tableView.indexPathsForRowsInRect(CGRectMake(0, targetContentOffset.memory.y, self.tableView.frame.width, self.tableView.frame.height))!
                let indexPath = temp.last
                self.needLoadArr.append(NSIndexPath(forRow: (indexPath?.row)! - 4, inSection: 0))
                self.needLoadArr.append(NSIndexPath(forRow: (indexPath?.row)! - 3, inSection: 0))
                self.needLoadArr.append(NSIndexPath(forRow: (indexPath?.row)! - 2, inSection: 0))
                self.needLoadArr.append(NSIndexPath(forRow: (indexPath?.row)! - 1, inSection: 0))
                self.needLoadArr.append(NSIndexPath(forRow: (indexPath?.row)! , inSection: 0))
                
                
                
            }else {
                self.needLoadArr.removeAll()
                
            }
        }
        
    }
    
    
    
    
    
    func loadData() {
        NetworkRequest.getWeiboDataFromUrl(getDataURL) { (json) -> Void in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                for(_,subJson):(String,JSON) in json["statuses"]{
                    let weibo = WeiboData(data: subJson)
                    self.weibos.append(weibo)
                    dispatch_async(requestDownloadPicQueue, { () -> Void in
                        NetworkRequest.downloadPicsFromWeiboData(weibo, delegate: self)
                    })
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            })
            
        }
    }
    
   
    
    func writePic_CacheToLocal() {
        dispatch_async(writeToLocalQueue) { () -> Void in
            let savePath = NSHomeDirectory() + pic_cache_directory + pic_cache_fileName
            let tmp = self.pic_Cache as NSDictionary
            tmp.writeToFile(savePath, atomically: true)
        }
    }
    
    
    func appendPic_Cache(key: Int, value: String) {
        self.pic_Cache[key] = value
    }
    
    func appendImg_Cache(key: String, value: CGImage, checkData:WeiboData) {
        self.img_Cache[key] = value
      /*  dispatch_async(createNewImageQueue, { () -> Void in
            if let newImage = SupportFunction.createImageWithWeiboData(checkData, delegate: self) {
                self.writePic_CacheToLocal()
                self.fullImg_Cache[checkData.id] = newImage
                self.img_Cache.removeValueForKey(checkData.user.profileImgUrl)
                self.img_Cache.removeValueForKey(checkData.smallPicUrl)
            }
        })*/
    }
        
    func getImageByKey(key: String) -> CGImage? {
        return img_Cache[key]
    }
    
    func getPathByKey(key: Int) -> String? {
        return pic_Cache[key]
    }
    
    func getFullImageByKey(key: Int) -> CGImage? {
        return fullImg_Cache[key]
    }
    
    func appendFullImg_Cache(key: Int, value: CGImage) {
        fullImg_Cache[key] = value
    }
    
    
    
    
    
    
}
