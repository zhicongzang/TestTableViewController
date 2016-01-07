//
//  DownloadTask.swift
//  DownloadTaskDemo
//
//  Created by Zhicong Zang on 10/21/15.
//  Copyright © 2015 Zhicong Zang. All rights reserved.
//

import Foundation

protocol DownloadTaskDelegata{
    func updateSpeed(speed:String)
    func updateProgress(progress:Int)
    func completed()
}





class DownloadTask:NSObject,NSURLSessionDownloadDelegate{
    
    let delegate: DownloadTaskDelegata                                      //  下载任务代理
    var data:DownloadData                                                   //  下载数据信息
    //private var id:Int                                                    //  下载任务id
    var task: NSURLSessionDownloadTask?                                     //  NSURLSessionDownloadTask
    var speed:[Int] = []                                                    //  下载速度
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()    //  默认会话配置
    var timer:NSTimer?                                                      //  计时器
    var isFinished = false
    
    
    init(data:DownloadData, delegate:DownloadTaskDelegata){
        self.data = data
        self.delegate = delegate
      //  self.id = id
        
    }
    
    
    func startDownloadTask() -> DownloadTask {
        
        // 使用默认配置创建一个会话，并将自身指定为代理
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        
        // 如果数据中的断点下载数据不为空，则创建一个继续下载任务
        if let tmpData = self.data.tmpData{
            task = session.downloadTaskWithResumeData(tmpData)
            print("\(self.data.name): continue downloading")
            self.data.tmpData = nil
        }
            
        // 否则创建一个新的下载任务
        else{
            if let url = NSURL(string: self.data.url){
                task = session.downloadTaskWithURL(url)
                print("\(self.data.name): start downloading")
            }
        }
        
        // 开始下载任务
        task?.resume()
        
        
        // 清零计时器
        timer?.invalidate()
        
        // 以0.25s的频率重复触发update方法
        timer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: "update", userInfo: nil, repeats: true)
        return self;
    }
    
    
    
    func pauseDownloadTask()-> DownloadTask{
        if let task = self.task{
            if task.state == .Running{
                //通过这个方法停止任务并生成一个NSData（记录下载数据信息）
                //将这个NSData存入DownloadData
                task.cancelByProducingResumeData({ (data) -> Void in
                    self.data.tmpData = data
                    self.speed = []
                    self.task = nil
                    print("\(self.data.name): paused")
                    self.timer?.invalidate()
                })
                
            }
        }
        return self
    }
    
    func cancelDownloadTask()-> Void{
        
        // 当有任务正在执行时，取消并清空任务
        if let task = self.task{
            task.cancel()
            self.task = nil
        }
        else if let tmpData = self.data.tmpData{
            let session = NSURLSession(configuration: config)
            task = session.downloadTaskWithResumeData(tmpData)
            task?.resume()
            task?.cancel()
            task = nil
        }
        
        // 清空记录下载信息数据文件
        self.data.tmpData = nil
        self.speed = []
        print("\(self.data.name): cancelled")
        self.timer?.invalidate()
    }
    
    
    // 通过speed[]中数据计算0.25s内的平均下载速度(Kb/s)
    func getSpeed() -> String{
        var r = 0
        for s in speed {
            r += s
        }
        speed = []
        // r为0.25s内总共写入数据总大小(byte)
        return "\(r/256)"
    }
    
    // 通过计时器触发，每0.25s，将速度数据传给代理
    func update(){
        delegate.updateSpeed(getSpeed())
    }
    

    
    
    
    // task完成后自动调用此方法
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        isFinished = true
        task = nil
        // 提示下载成功并更新代理数据
        print("\(self.data.name): downloaded successful")
        timer?.invalidate()
        delegate.updateSpeed("")
        delegate.completed()
        
        // 将下载完的临时文件移动至目标位置
        if let fromPath = location.path{
            do{
                if(NSFileManager.defaultManager().fileExistsAtPath(self.data.savePath)){
                    try NSFileManager.defaultManager().removeItemAtPath(self.data.savePath)
                }
                try NSFileManager.defaultManager().moveItemAtPath(fromPath, toPath: self.data.savePath)
            }catch{
                print("\(self.data.name): Move failed")
                print(self.data.savePath)
            }
        }else{
            print("\(self.data.name): Wrong fromPath")
        }
        
    }
    
    // 执行task过程中不停重复调用次方法，并获得调用间隙写入数据大小，总写入数据大小及预期总写入数据大小三个值
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        // 将调用间隙写入数据大小存入数组备用
        self.speed.append(Int(bytesWritten))
        
        // 将已下载百分比传给代理方法
        delegate.updateProgress(Int(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite) * 100))
    }
    
    func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
        print("\(self.data.name): \(error)")
    }
    
    
    
}