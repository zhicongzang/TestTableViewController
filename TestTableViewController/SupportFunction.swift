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


class SupportFunction {
    class func getScreenWidth() -> CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    
    class func checkPicCacheDirectory() -> [String:String]{
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
                return cache as! [String:String]
            }
        }
        return [:]
    }
    
    class func cellHeightByData(data:WeiboData) -> CGFloat{
        return 8 + 50 + 8 + data.text.stringHeightWith(17, width: SupportFunction.getScreenWidth() - 55 * 2) + 8 + 28 + 20
    }
    
    class func createImageWithWeiboData(data:WeiboData, delegate: pic_CacheDegelate) -> CGImage? {
        if let userPic = delegate.getImageByKey(data.user.profileImgUrl), let pic = delegate.getImageByKey(data.smallPicUrl), let height = delegate.getCellHeightByID(data.id) {
            UIGraphicsBeginImageContext(CGSizeMake(getScreenWidth(), height))
            let context = UIGraphicsGetCurrentContext()
            let  attributes = [NSFontAttributeName:UIFont(name: "HelveticaNeue-UltraLight", size: 17)!,
                NSParagraphStyleAttributeName:NSMutableParagraphStyle().copy()]
            data.user.name.drawInRect(CGRect(x: 66 , y: 8, width: SupportFunction.getScreenWidth() - 66 - 8, height: 25), withAttributes: attributes)
            data.text.heightLightString([StringSearchingOptions.WeiboURL,StringSearchingOptions.WeiboUserName,StringSearchingOptions.WeiboHot]).drawInRect(CGRect(x: 66 , y: 66, width: SupportFunction.getScreenWidth() - 110, height: data.text.stringHeightWith(17, width: SupportFunction.getScreenWidth() -  110)))
            CGContextScaleCTM(context, 1, -1)
            CGContextDrawImage(context, CGRect(x: 8, y: -8, width: 50, height: -50), userPic)
            CGContextDrawImage(context, CGRect(x: 66, y: -(66 + data.text.stringHeightWith(17, width: SupportFunction.getScreenWidth() -  110) + 8 ), width: 150 * CGFloat(CGImageGetWidth(pic)) / CGFloat(CGImageGetHeight(pic)), height: -150), pic)
            let new = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            print("\(data.user.name): Full Image Created")
            return new.CGImage
        }
        return nil
    }
    
}