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
    func appendPic_Cache(key:String, value:String)
    func appendImg_Cache(key:String, value:CGImage)
}

class NetworkRequest {
    
    class func fillUIImageWithImageUrl(imgView:UIImageView, imgUrl:String, cache: [String: String], delegate:pic_CacheDegelate) {
        if imgUrl != "" {
            if let localPath = Cache.searchDataFromCache(imgUrl, cache: cache) where NSFileManager.defaultManager().fileExistsAtPath(localPath), let localPic = NSFileManager.defaultManager().contentsAtPath(localPath){
                    imgView.image = UIImage(data: localPic)
            }else {
                let saveName = imgUrl.md5
                Alamofire.request(.GET, imgUrl).responseData({ (response) -> Void in
                    if let img:NSData = response.result.value {
                        let savePath = NSHomeDirectory() + "/Documents/Pic_Cache/\(saveName).jpg" //地址加密
                        //加入字典
                        delegate.appendPic_Cache(imgUrl, value: savePath)
                  //      dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            img.writeToFile(savePath, atomically: true)
                            if let image = UIImage(data: img) {
                                if let imageScaled = UIImage(data: img, scale: image.size.height/150){
                                    imgView.image = imageScaled
                                    if let saveData = UIImageJPEGRepresentation(imageScaled, 1.0){
                                        saveData.writeToFile(savePath, atomically: true)
                                    }
                                }
                            }
                   //     })
                    }
                })
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                imgView.image = nil
            })
        }
    }
    
    class func addImageLayerToView(imageLayer: CALayer,view: UIView, imgUrl: String, cache: [String: String], delegate: pic_CacheDegelate, saveImageQueue: dispatch_queue_t, img_Cache:[String:CGImage]) {
        if let img = img_Cache[imgUrl] {
            imageLayer.contents = img
            view.layer.addSublayer(imageLayer)
        }else if let localPath = Cache.searchDataFromCache(imgUrl, cache: cache) where NSFileManager.defaultManager().fileExistsAtPath(localPath), let localPic = NSFileManager.defaultManager().contentsAtPath(localPath){
            imageLayer.contents = UIImage(data: localPic)?.CGImage
            view.layer.addSublayer(imageLayer)
        } else {
            let saveName = imgUrl.md5
            Alamofire.request(.GET, imgUrl).responseData({ (response) -> Void in
                dispatch_async(saveImageQueue, { () -> Void in
                    if let img:NSData = response.result.value {
                        let savePath = NSHomeDirectory() + "/Documents/Pic_Cache/\(saveName).jpg" //地址加密
                        //加入字典
                        delegate.appendPic_Cache(imgUrl, value: savePath)
                        img.writeToFile(savePath, atomically: true)
                        if let image = UIImage(data: img) {
                                //  UIGraphicsBeginImageContextWithOptions(imageScaled.size, true, 0)
                                delegate.appendImg_Cache(imgUrl, value: image.CGImage!)
                                if let saveData = UIImageJPEGRepresentation(image, 1.0){
                                    saveData.writeToFile(savePath, atomically: true)
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    imageLayer.contents = image.CGImage
                                    view.layer.addSublayer(imageLayer)
                                })
                                
                                
                            }
                        }
                    
                })
            })
        }
    }
    
    class func downloadPicFromWeiboData(data:WeiboData, cache:[String: String], delegate: pic_CacheDegelate, saveImageQueue:dispatch_queue_t) {
        if Cache.searchDataFromCache(data.user.profileImgUrl, cache: cache) == nil {
            let saveName = data.user.profileImgUrl.md5
            Alamofire.request(.GET, data.user.profileImgUrl).responseData({ (response) -> Void in
                dispatch_async(saveImageQueue, { () -> Void in
                    if let img:NSData = response.result.value {
                        let savePath = NSHomeDirectory() + "/Documents/Pic_Cache/\(saveName).jpg" //地址加密
                        //加入字典
                        delegate.appendPic_Cache(data.user.profileImgUrl, value: savePath)
                        img.writeToFile(savePath, atomically: true)
                        if let image = UIImage(data: img) {
                            //  UIGraphicsBeginImageContextWithOptions(imageScaled.size, true, 0)
                            
                            if let saveData = UIImageJPEGRepresentation(image, 1.0){
                                saveData.writeToFile(savePath, atomically: true)
                            }
                        }
                    }
                })
            })
        }
        if data.smallPicUrl != "" && Cache.searchDataFromCache(data.smallPicUrl, cache: cache) == nil {
            let saveName = data.smallPicUrl.md5
            Alamofire.request(.GET, data.smallPicUrl).responseData({ (response) -> Void in
                dispatch_async(saveImageQueue, { () -> Void in
                    if let img:NSData = response.result.value {
                        let savePath = NSHomeDirectory() + "/Documents/Pic_Cache/\(saveName).jpg" //地址加密
                        //加入字典
                        delegate.appendPic_Cache(data.smallPicUrl, value: savePath)
                        img.writeToFile(savePath, atomically: true)
                        if let image = UIImage(data: img) {
                            //  UIGraphicsBeginImageContextWithOptions(imageScaled.size, true, 0)
                            
                            if let saveData = UIImageJPEGRepresentation(image, 1.0){
                                saveData.writeToFile(savePath, atomically: true)
                            }
                        }
                    }
                })
            })
        }
    }
    
}
