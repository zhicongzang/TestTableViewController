//
//  DownloadManager.swift
//  DownloadTaskDemo
//
//  Created by Zhicong Zang on 10/28/15.
//  Copyright © 2015 Zhicong Zang. All rights reserved.
//

import Foundation

enum TaskState{
    case Downloading,Waiting,Paused,Nil
}

protocol DownloadManagerDelegata{
    func updateSpeed(speed:String, id:Int)
    func updateProgress(progress:Int, id:Int)
    func completed(id:Int)
}

class DownloadManager:DownloadTaskDelegata{
    let delegate: DownloadManagerDelegata
    private var downloadingTaskCollection:[DownloadTask] = []
    private var waitingTaskCollection:[DownloadTask] = []
    private var pausedTaskCollection:[DownloadTask] = []
    private var maxDownloadTaskNumber = 5
    
    
    init(delegate:DownloadManagerDelegata){
        self.delegate = delegate
      //  loadingTaskInfoFromLocal()
    }
    
    func changeMaxDownloadTaskNumber(num:Int){
        if num>=1 {
            self.maxDownloadTaskNumber = num
            autoDownload()
        }else {
            print("Wrong max number")
        }
    }
    
    func autoDownload(){
        while downloadingTaskCollection.count < maxDownloadTaskNumber && waitingTaskCollection.count > 0{
            downloadingTaskCollection.append(waitingTaskCollection.removeFirst().startDownloadTask())
        }
        while downloadingTaskCollection.count > maxDownloadTaskNumber {
            waitingTaskCollection.insert(downloadingTaskCollection.removeLast().pauseDownloadTask(), atIndex: 0)
        }
        saveingTaskInfoToLocal()
    }
    
    func startAllDownloadTask(){
        while pausedTaskCollection.count > 0 {
            waitingTaskCollection.append(pausedTaskCollection.removeFirst())
        }
        autoDownload()
    }
    
    func startDownloadTask(id:Int){
        let p_id = id - downloadingTaskCollection.count - waitingTaskCollection.count
        if downloadingTaskCollection.count < maxDownloadTaskNumber {
            downloadingTaskCollection.append(pausedTaskCollection.removeAtIndex(p_id).startDownloadTask())
        }else{
            waitingTaskCollection.append(pausedTaskCollection.removeAtIndex(p_id))
        }
        saveingTaskInfoToLocal()
    }
    
    func pauseAllDownloadTask(){
        while waitingTaskCollection.count > 0 {
            pausedTaskCollection.insert(waitingTaskCollection.removeLast(), atIndex: 0)
        }
        while downloadingTaskCollection.count > 0 {
            pausedTaskCollection.insert(downloadingTaskCollection.removeLast().pauseDownloadTask(), atIndex: 0)
        }
        saveingTaskInfoToLocal()
        
        
        
    }
    
    func pauseDownloadTask(id:Int){
        if id - downloadingTaskCollection.count < 0 {
            pausedTaskCollection.insert(downloadingTaskCollection.removeAtIndex(id).pauseDownloadTask(), atIndex: 0)
        }else {
            pausedTaskCollection.insert(waitingTaskCollection.removeAtIndex(id - downloadingTaskCollection.count), atIndex: 0)
        }
        autoDownload()
    }
    
    func cancelAllDownloadTask(){
        pausedTaskCollection.removeAll()
        waitingTaskCollection.removeAll()
        while downloadingTaskCollection.count > 0 {
            downloadingTaskCollection.removeFirst().cancelDownloadTask()
        }
    }
    
    func cancelDownloadTask(id:Int){
        if id - downloadingTaskCollection.count < 0{
            downloadingTaskCollection.removeAtIndex(id).cancelDownloadTask()
            autoDownload()
        }else if id - downloadingTaskCollection.count - waitingTaskCollection.count >= 0{
            pausedTaskCollection.removeAtIndex(id - downloadingTaskCollection.count - waitingTaskCollection.count)
        }else{
            waitingTaskCollection.removeAtIndex(id - downloadingTaskCollection.count)
        }
    }
    
    func createDownloadTask(data:DownloadData){
        self.waitingTaskCollection.append(DownloadTask(data: data, delegate: self))
        autoDownload()
    }
    
    
    func showAllTaskInformation()->[DownloadTask]{
        return downloadingTaskCollection + waitingTaskCollection + pausedTaskCollection
    }
    
    func showDownloadingTaskInformation()->[DownloadTask]{
        return downloadingTaskCollection
    }
    func showWaitingTaskInformation()->[DownloadTask]{
        return waitingTaskCollection
    }
    func showPausedTaskInformation()->[DownloadTask]{
        return pausedTaskCollection
    }
    
    func showTaskInformation(index:Int) -> TaskState{
        if index < downloadingTaskCollection.count{
            return TaskState.Downloading
        }else if index < downloadingTaskCollection.count + waitingTaskCollection.count{
            return TaskState.Waiting
        }else if index < downloadingTaskCollection.count + waitingTaskCollection.count + pausedTaskCollection.count {
            return TaskState.Paused
        }else{
            return TaskState.Nil
        }
    }
    
    // For TableView
    func switchTask(moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath){
        switch sourceIndexPath.section{
        case 0:
            if destinationIndexPath.section == 0{
                downloadingTaskCollection.insert(downloadingTaskCollection.removeAtIndex(sourceIndexPath.row), atIndex: destinationIndexPath.row)
            }
            if destinationIndexPath.section == 1{
                waitingTaskCollection.insert(downloadingTaskCollection.removeAtIndex(sourceIndexPath.row).pauseDownloadTask(), atIndex: destinationIndexPath.row)
            }
            if destinationIndexPath.section == 2 {
                pausedTaskCollection.insert(downloadingTaskCollection.removeAtIndex(sourceIndexPath.row).pauseDownloadTask(), atIndex: destinationIndexPath.row)
            }
            autoDownload()
            break
        case 1:
            if destinationIndexPath.section == 0{
                downloadingTaskCollection.insert(waitingTaskCollection.removeAtIndex(sourceIndexPath.row).startDownloadTask(), atIndex: destinationIndexPath.row)
            }
            if destinationIndexPath.section == 1{
                waitingTaskCollection.insert(waitingTaskCollection.removeAtIndex(sourceIndexPath.row), atIndex: destinationIndexPath.row)
            }
            if destinationIndexPath.section == 2 {
                pausedTaskCollection.insert(waitingTaskCollection.removeAtIndex(sourceIndexPath.row), atIndex: destinationIndexPath.row)
            }
            autoDownload()
            break
        case 2:
            if destinationIndexPath.section == 0{
                downloadingTaskCollection.insert(pausedTaskCollection.removeAtIndex(sourceIndexPath.row).startDownloadTask(), atIndex: destinationIndexPath.row)
            }
            if destinationIndexPath.section == 1{
                waitingTaskCollection.insert(pausedTaskCollection.removeAtIndex(sourceIndexPath.row), atIndex: destinationIndexPath.row)
            }
            if destinationIndexPath.section == 2 {
                pausedTaskCollection.insert(pausedTaskCollection.removeAtIndex(sourceIndexPath.row), atIndex: destinationIndexPath.row)
            }
            autoDownload()
            break
        default:
            break
        }
    }
    
    func loadingTaskInfoFromLocal(){
        let savePath = NSHomeDirectory() + "/Documents/taskData.plist"
        if NSFileManager.defaultManager().fileExistsAtPath(savePath) {
            if let dictData = NSDictionary(contentsOfFile: savePath){
                if let dTmp = dictData["D"] as? [DownloadTask]{
                    downloadingTaskCollection = dTmp
                }
                if let wTmp = dictData["W"] as? [DownloadTask]{
                    waitingTaskCollection = wTmp
                }
                if let pTmp = dictData["P"] as? [DownloadTask]{
                    pausedTaskCollection = pTmp
                }
                do {
                    try NSFileManager.defaultManager().removeItemAtPath(savePath)
                }
                catch {
                    print("Delete Failed!")
                }
                print("Loaded suucessfullly")
            }
            
        }
    }
    
    func saveingTaskInfoToLocal(){
        if downloadingTaskCollection != [] || waitingTaskCollection != [] || pausedTaskCollection != []{
            let savePath = NSHomeDirectory() + "/Documents/taskData.plist"
            if NSFileManager.defaultManager().fileExistsAtPath(savePath){
                do {
                    try NSFileManager.defaultManager().removeItemAtPath(savePath)
                }
                catch {
                    print("Delete Failed!")
                }
            }
            let dictData:NSDictionary = ["D":downloadingTaskCollection,"W":waitingTaskCollection,"P":pausedTaskCollection]
            print(dictData)
            dictData.writeToFile(savePath, atomically: true)
            print(savePath)
            print("Saved suucessfullly")
        }
    }
    
    
    
    
    
    
    
    func completed() {
        for i in 0...downloadingTaskCollection.count-1 {
            if downloadingTaskCollection[i].isFinished {
                downloadingTaskCollection.removeAtIndex(i)
                autoDownload()
                delegate.completed(i)
                break
            }
        }
        
    }
    
    func updateProgress(progress: Int) {
        if downloadingTaskCollection.count > 0 {
            for i in 0...downloadingTaskCollection.count-1{
                delegate.updateProgress(progress, id: i)
            }
        }
    }
    
    func updateSpeed(speed: String) {
        if downloadingTaskCollection.count > 0 {
            for i in 0...downloadingTaskCollection.count-1{
                delegate.updateSpeed(speed, id: i)
            }
        }
    }
}
