//
//  SupportFunction.swift
//  TestTableViewController
//
//  Created by ZZC on 12/12/15.
//  Copyright © 2015 Zhicong Zang. All rights reserved.
//

import Foundation
import UIKit

let pic_cache_directory = "/Documents/Pic_Cache"
let pic_cache_fileName = "/pic_Cache.plist"
let getDataURL = "https://api.weibo.com/2/statuses/public_timeline.json?access_token=2.00kK7JSG0IVHcF73dc2cde89OU4MQC"
let lineImage = UIImage(named: "Line.png")!
//let fontName = "HelveticaNeue-UltraLight"
let fontName = "STHeitiTC-Light"
let fontSize:CGFloat = 17




class SupportFunction {
    class func getScreenWidth() -> CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    
    class func checkPicCacheDirectory() -> [Int:String]{
        let localPath = NSHomeDirectory() + pic_cache_directory
        print(localPath)
        if !NSFileManager.defaultManager().fileExistsAtPath(localPath) {
            do{
                try NSFileManager.defaultManager().createDirectoryAtPath(localPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                print("Create Directory Fail")
            }
        }else {
            let cachePath = localPath + pic_cache_fileName
            if NSFileManager.defaultManager().fileExistsAtPath(cachePath) {
                let cache = NSDictionary(contentsOfFile: cachePath)
                return cache as! [Int:String]
            }
        }
        return [:]
    }
    
    class func cellHeightByData(text:String) -> CGFloat{
        return 8 + 50 + 8 + text.stringHeightWith(17, width: SupportFunction.getScreenWidth() - 55 * 2) + 8 + 28 + 10
    }
    
    class func createImageWithWeiboData(data:WeiboData, delegate: pic_CacheDegelate) -> CGImage? {
        let height = data.getHeight()
        if data.smallPicUrl == "" {
            if let userPic = delegate.getImageByKey(data.user.profileImgUrl) {
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(getScreenWidth(), height), false, 0.0)
                let context = UIGraphicsGetCurrentContext()
                let  attributes = [NSFontAttributeName:UIFont(name: fontName, size: fontSize)!,
                    NSParagraphStyleAttributeName:NSMutableParagraphStyle().copy()]
                data.user.name.drawInRect(CGRect(x: 66 , y: 8, width: SupportFunction.getScreenWidth() - 66 - 8, height: 25), withAttributes: attributes)
                data.text.heightLightString([StringSearchingOptions.WeiboURL,StringSearchingOptions.WeiboUserName,StringSearchingOptions.WeiboHot]).drawInRect(CGRect(x: 66 , y: 66, width: SupportFunction.getScreenWidth() - 110, height: height - 112))
                CGContextScaleCTM(context, 1, -1)
                CGContextDrawImage(context, CGRect(x: 8, y: -8, width: 50, height: -50), userPic)
                CGContextDrawImage(context, CGRect(x: 0, y: -(height - 38), width: getScreenWidth(), height: -38), lineImage.CGImage)
                let new = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
             /*   dispatch_async(saveImageQueue, { () -> Void in
                    if let imgDate = UIImagePNGRepresentation(new) {
                        let savePath = NSHomeDirectory() + pic_cache_directory + "/\(data.id).png"
                        imgDate.writeToFile(savePath, atomically: true)
                        delegate.appendPic_Cache(data.id, value: savePath)
                        
                    }
                })*/
                return new.CGImage
            }
        } else {
            if let userPic = delegate.getImageByKey(data.user.profileImgUrl), let pic = delegate.getImageByKey(data.smallPicUrl) {
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(getScreenWidth(), height), false, 0.0)
                let context = UIGraphicsGetCurrentContext()
                let  attributes = [NSFontAttributeName:UIFont(name: fontName, size: fontSize)!,
                    NSParagraphStyleAttributeName:NSMutableParagraphStyle().copy()]
                data.user.name.drawInRect(CGRect(x: 66 , y: 8, width: SupportFunction.getScreenWidth() - 66 - 8, height: 25), withAttributes: attributes)
                data.text.heightLightString([StringSearchingOptions.WeiboURL,StringSearchingOptions.WeiboUserName,StringSearchingOptions.WeiboHot]).drawInRect(CGRect(x: 66 , y: 66, width: SupportFunction.getScreenWidth() - 110, height: height - 112 - 150 - 8))
                CGContextScaleCTM(context, 1, -1)
                CGContextDrawImage(context, CGRect(x: 8, y: -8, width: 50, height: -50), userPic)
                CGContextDrawImage(context, CGRect(x: 66, y: -(66 + height - 112 - 150), width: 150 * CGFloat(CGImageGetWidth(pic)) / CGFloat(CGImageGetHeight(pic)), height: -150), pic)
                CGContextDrawImage(context, CGRect(x: 0, y: -(height - 38), width: getScreenWidth(), height: -38), lineImage.CGImage)
                let new = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
           /*     dispatch_async(saveImageQueue, { () -> Void in
                    if let imgDate = UIImagePNGRepresentation(new) {
                        let savePath = NSHomeDirectory() + pic_cache_directory + "/\(data.id).png"
                        imgDate.writeToFile(savePath, atomically: true)
                        delegate.appendPic_Cache(data.id, value: savePath)
                        
                    }
                }) */
                return new.CGImage
            }

        }
        return nil
    }
    //Create Line.png
  
    class func createImg(){
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(getScreenWidth(), 28 + 10),false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        CGContextScaleCTM(context, 1, -1)
        UIColor(white: 0.66, alpha: 1).set()
        CGContextSetLineWidth(context, 0.4)
        CGContextMoveToPoint(context, 0, -0.2)
        CGContextAddLineToPoint(context, SupportFunction.getScreenWidth(), -0.2)
        CGContextStrokePath(context)
        CGContextMoveToPoint(context, 0, -27.8)
        CGContextAddLineToPoint(context, SupportFunction.getScreenWidth(), -27.8)
        CGContextStrokePath(context)
        CGContextMoveToPoint(context, SupportFunction.getScreenWidth()/3, -0.2)
        CGContextAddLineToPoint(context, SupportFunction.getScreenWidth()/3, -27.8)
        CGContextStrokePath(context)
        CGContextMoveToPoint(context, 2 * SupportFunction.getScreenWidth()/3, -0.2)
        CGContextAddLineToPoint(context, 2 * SupportFunction.getScreenWidth()/3, -27.8)
        CGContextStrokePath(context)
        UIColor(white: 0.66, alpha: 0.3).set()
        CGContextSetLineWidth(context, 10)
        CGContextMoveToPoint(context, 0, -33)
        CGContextAddLineToPoint(context, SupportFunction.getScreenWidth(), -33)
        CGContextStrokePath(context)
        let new = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImagePNGRepresentation(new)?.writeToFile(NSHomeDirectory()  + "111.png", atomically: true)
    }
    
}