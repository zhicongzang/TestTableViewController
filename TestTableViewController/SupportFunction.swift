//
//  SupportFunction.swift
//  TestTableViewController
//
//  Created by ZZC on 12/12/15.
//  Copyright © 2015 Zhicong Zang. All rights reserved.
//

import Foundation
import UIKit

class SupportFunction {
    class func getScreenWidth() -> CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    
    class func checkPicCacheDirectory() -> [String:String]{
        let localPath = NSHomeDirectory() + "/Documents/Pic_Cache"
        if !NSFileManager.defaultManager().fileExistsAtPath(localPath) {
            do{
                try NSFileManager.defaultManager().createDirectoryAtPath(localPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                print("Create Directory Fail")
            }
        }else {
            let cachePath = localPath + "/pic_Cache.plist"
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
    
}