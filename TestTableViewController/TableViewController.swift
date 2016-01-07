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

    var weibos: [WeiboData] = []
    
    var cellHeightCache:[Int:CGFloat] = [:]
    var token = ""
    
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
      
       // let cell = tableView.dequeueReusableCellWithIdentifier("Weibo", forIndexPath: indexPath) as! WeiboCell
       // cell.setWeiboData(weibos[indexPath.row], pic_Cache: pic_Cache, delegate: self)
        

        let cell = tableView.dequeueReusableCellWithIdentifier("P", forIndexPath: indexPath) as! PWeiboCell
        cell.drawCell(weibos[indexPath.row], pic_Cache: pic_Cache, delegate: self)
    
        return cell
        
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 300              //预估高度，提高首次运行效率
    }
    

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let data = weibos[indexPath.row]
        if let height = cellHeightCache[data.id] {
            return height
        }else {
            if weibos[indexPath.row].smallPicUrl != "" {
                cellHeightCache[data.id] = WeiboCell.cellHeightByData(data) + 150 + 8
            }else {
                cellHeightCache[data.id] = WeiboCell.cellHeightByData(data)
            }
            return cellHeightCache[data.id]!
        }
        
        

    }
    
    
    
    
    func loadData(){
        Alamofire.request(.GET, "https://api.weibo.com/2/statuses/public_timeline.json?access_token=2.00kK7JSG0IVHcF73dc2cde89OU4MQC").responseJSON { (response) -> Void in
            switch response.result{
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    for(_,subJson):(String,JSON) in json["statuses"]{
                        let weibo = WeiboData(data: subJson)
                        self.weibos.append(weibo)
                    }
                }
                self.tableView.reloadData()
                
            case .Failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func appendPic_Cache(key: String, value: String) {
        pic_Cache[key] = value
        let savePath = NSHomeDirectory() + "/Documents/Pic_Cache/pic_Cache.plist"
        let tmp = pic_Cache as NSDictionary
        tmp.writeToFile(savePath, atomically: true)
    }
    


}
