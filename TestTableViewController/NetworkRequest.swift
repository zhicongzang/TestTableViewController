//
//  NetworkRequest.swift
//  TestTableViewController
//
//  Created by Zhicong Zang on 12/11/15.
//  Copyright © 2015 Zhicong Zang. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import SwiftyJSON

protocol pic_CacheDegelate {
    var pic_Cache: [String:String] {get set}
    var img_Cache: [String:CGImage] {get set}
    func appendPic_Cache(key:String, value:String)
    func appendImg_Cache(key:String, value:CGImage)
    func getPathByKey(key:String) -> String?
    func getImageByKey(key:String) -> CGImage?
}


class NetworkRequest {
    
    
    class func downloadPicFromUrl(imgUrl: String, delegate: pic_CacheDegelate, saveImageQueue: dispatch_queue_t, completed:(CGImage) -> Void) {
        if imgUrl != "" {
            Alamofire.request(.GET, imgUrl).responseData { (response) -> Void in
                if let data = response.result.value {
                    if let uiImg = UIImage(data: data), let image = uiImg.CGImage {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                            completed(image)
                        })
                        dispatch_async(saveImageQueue, { () -> Void in
                            let saveName = imgUrl.md5
                            let savePath = NSHomeDirectory() + "/Documents/Pic_Cache/\(saveName).jpg"
                            delegate.appendPic_Cache(imgUrl, value: savePath)
                            data.writeToFile(savePath, atomically: true)
                        })
                        dispatch_async(saveImageQueue, { () -> Void in
                            delegate.appendImg_Cache(imgUrl, value: image)
                        
                        })
                    }
                }
            }
        }
    }
    
    class func loadPic(imgUrl: String, delegate: pic_CacheDegelate, saveImageQueue: dispatch_queue_t, completed:(CGImage) -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            if imgUrl != "" {
                if let image = delegate.getImageByKey(imgUrl) {
                    completed(image)
                }else if let localPath = delegate.getPathByKey(imgUrl) where NSFileManager.defaultManager().fileExistsAtPath(localPath), let localPic = NSFileManager.defaultManager().contentsAtPath(localPath), let uiImg = UIImage(data: localPic), let image = uiImg.CGImage {
                    dispatch_async(saveImageQueue, { () -> Void in
                        delegate.appendImg_Cache(imgUrl, value: image)
                    })
                    completed(image)
                }else {
                    downloadPicFromUrl(imgUrl, delegate: delegate, saveImageQueue: saveImageQueue, completed: completed)
                }
            }
        })
        
    }
    
}
