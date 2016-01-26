//
//  NetworkRequest.swift
//  TestTableViewController
//
//  Created by Zhicong Zang on 12/11/15.
//  Copyright © 2015 Zhicong Zang. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

protocol pic_CacheDegelate {
    func appendPic_Cache(key:Int, value:String)
    func appendImg_Cache(key:String, value:CGImage, checkData:WeiboData)
    func appendFullImg_Cache(key:Int, value:CGImage)
    func getPathByKey(key:Int) -> String?
    func getImageByKey(key:String) -> CGImage?
    func getFullImageByKey(key: Int) -> CGImage?
}


class NetworkRequest {
    
    class func downloadPicsFromWeiboData(weiboData:WeiboData, delegate: pic_CacheDegelate) {
        if let savePath = delegate.getPathByKey(weiboData.id), let uiFullImage = UIImage(contentsOfFile: savePath), let fullImage = uiFullImage.CGImage {
            delegate.appendFullImg_Cache(weiboData.id, value: fullImage)
        }else{
            let userPicUrlString = weiboData.user.profileImgUrl
            let picUrlString = weiboData.smallPicUrl
            dispatch_async(downloadPicQueue) { () -> Void in
                if let url = NSURL(string: userPicUrlString) {
                    let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
                    let task = session.dataTaskWithURL(url, completionHandler: { (d, _, error) -> Void in
                        if let data = d {
                            if let uiImg = UIImage(data: data), let image = uiImg.circleImage().CGImage {
                                delegate.appendImg_Cache(userPicUrlString, value: image, checkData: weiboData)

                            }
                        }
                    })
                    task.resume()
                }
                
            }
            
            if picUrlString != "" {
                dispatch_async(downloadPicQueue) { () -> Void in
                    if let url = NSURL(string: picUrlString) {
                        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
                        let task = session.dataTaskWithURL(url, completionHandler: { (d, _, error) -> Void in
                            if let data = d {
                                if let uiImg = UIImage(data: data), let image = uiImg.CGImage {
                                    delegate.appendImg_Cache(picUrlString, value: image, checkData: weiboData)
                                }
                            }
                        })
                        task.resume()
                    }
                }
            }
        }
        
        
    }
    
    class func getWeiboDataFromUrl(stringUrl: String, completed:(JSON) -> Void) {
        if let url = NSURL(string: stringUrl) {
            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            let task = session.dataTaskWithURL(url, completionHandler: { (d, _, error) -> Void in
                if let data = d {
                    do {
                        if let j = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
                            let json = JSON(j)
                            completed(json)
                        }
                        
                    }catch _ {
                        print("Error")
                    }
                    
                }
            })
            task.resume()
        }
    }
    
}
