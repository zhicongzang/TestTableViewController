//
//  Data.swift
//  DownloadTaskDemo
//
//  Created by Zhicong Zang on 10/27/15.
//  Copyright © 2015 Zhicong Zang. All rights reserved.
//

import Foundation

struct DownloadData{
    
    //下载任务URL地址
    let url:String
    
    //任务名字
    let name:String
    
    //本地沙盒地址
    let localPath:String = NSHomeDirectory() + "/Documents"
    
    //文件存储目标地址
    let savePath:String
    
    //保存用于断点下载的NSData
    var tmpData: NSData?
    
    //构造器
    init(url:String,name:String){
        self.url = url
        self.name = name
        self.savePath = localPath.stringByAppendingString("/\(name)")
    }
}