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
    func appendPic_Cache(key:String, value:String)
    func appendImg_Cache(key:String, value:CGImage, checkData:WeiboData)
    func getPathByKey(key:String) -> String?
    func getImageByKey(key:String) -> CGImage?
    func getCellHeightByID(id: Int) -> CGFloat?
    func getFullImageByKey(key: Int) -> CGImage?
}


class NetworkRequest {
    
    
    class func downloadPicsFromUrl(weiboData:WeiboData, delegate: pic_CacheDegelate) {
        let userPicUrlString = weiboData.user.profileImgUrl
        let picUrlString = weiboData.smallPicUrl
        dispatch_async(downloadPicQueue) { () -> Void in
            if let path = delegate.getPathByKey(userPicUrlString), let uiImg = UIImage(contentsOfFile: path), let image = uiImg.CGImage{
                delegate.appendImg_Cache(userPicUrlString, value: image, checkData: weiboData)
            }else {
                if let url = NSURL(string: userPicUrlString) {
                    let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
                    let task = session.dataTaskWithURL(url, completionHandler: { (d, _, error) -> Void in
                        if let data = d {
                            if let uiImg = UIImage(data: data), let image = uiImg.circleImage().CGImage {
                                delegate.appendImg_Cache(userPicUrlString, value: image, checkData: weiboData)
                                dispatch_async(saveImageQueue, { () -> Void in
                                    let saveName = userPicUrlString.md5
                                    let savePath = NSHomeDirectory() + pic_cache_directory + "/\(saveName).jpg"
                                    delegate.appendPic_Cache(userPicUrlString, value: savePath)
                                    data.writeToFile(savePath, atomically: true)
                                })
                            }
                        }
                    })
                    task.resume()
                }
            }
        }
        
        if picUrlString != "" {
            dispatch_async(downloadPicQueue) { () -> Void in
                if let path = delegate.getPathByKey(picUrlString), let uiImg = UIImage(contentsOfFile: path), let image = uiImg.CGImage{
                    delegate.appendImg_Cache(picUrlString, value: image, checkData: weiboData)
                }else {
                    if let url = NSURL(string: picUrlString) {
                        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
                        let task = session.dataTaskWithURL(url, completionHandler: { (d, _, error) -> Void in
                            if let data = d {
                                if let uiImg = UIImage(data: data), let image = uiImg.CGImage {
                                    delegate.appendImg_Cache(picUrlString, value: image, checkData: weiboData)
                                    dispatch_async(saveImageQueue, { () -> Void in
                                        let saveName = picUrlString.md5
                                        let savePath = NSHomeDirectory() + pic_cache_directory + "/\(saveName).jpg"
                                        delegate.appendPic_Cache(picUrlString, value: savePath)
                                        data.writeToFile(savePath, atomically: true)
                                    })
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
                        print("asdad")
                    }
                    
                }
            })
            task.resume()
        }
    }
    
}
