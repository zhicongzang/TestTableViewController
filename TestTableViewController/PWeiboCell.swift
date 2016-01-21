//
//  PWeiboCell.swift
//  TestTableViewController
//
//  Created by Zhicong Zang on 12/16/15.
//  Copyright © 2015 Zhicong Zang. All rights reserved.
//

import UIKit
import Alamofire



class PWeiboCell: UITableViewCell, PWeiboCellDelegate {
    
    var userName:String?
    var context:String?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
 /*   func drawCell(data: WeiboData, pic_Cache:[String:String], delegate: pic_CacheDegelate,saveImageQueue: dispatch_queue_t,img_Cache:[String:CGImage]) {
        clearSubLayers()
        let textHeight = data.text.stringHeightWith(17, width: SupportFunction.getScreenWidth() -  110)
        drawUserPic(data.user.profileImgUrl, pic_Cache: pic_Cache, delegate: delegate, saveImageQueue: saveImageQueue, img_Cache: img_Cache)
       // drawImage(data.smallPicUrl, pic_Cache: pic_Cache, delegate: delegate, textHeight: textHeight, saveImageQueue: saveImageQueue)
    }
 */
    
    func drawCell(data:WeiboData, delegate: pic_CacheDegelate, saveImageQueue: dispatch_queue_t) {
        clearSubLayers()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
            let userImgLayer = CALayer()
            userImgLayer.contentsScale = UIScreen.mainScreen().scale
            userImgLayer.frame = CGRect(x: 8, y: 8, width: 50, height: 50)
            userImgLayer.cornerRadius = 25
            userImgLayer.masksToBounds = true
            NetworkRequest.loadPic(data.user.profileImgUrl, delegate: delegate, cellDelegate: self, layer: userImgLayer, saveImageQueue: saveImageQueue)
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
            let imgLayer = CALayer()
            imgLayer.contentsScale = UIScreen.mainScreen().scale
            imgLayer.frame = CGRect(x: 66, y: 66 + data.text.stringHeightWith(17, width: SupportFunction.getScreenWidth() -  110) + 8 , width: 50, height: 50)
            NetworkRequest.loadPic(data.smallPicUrl, delegate: delegate, cellDelegate: self, layer: imgLayer, saveImageQueue: saveImageQueue)
        }
    }
    
    
    override func drawRect(rect: CGRect) {
        
        let  attributes = [NSFontAttributeName:UIFont(name: "HelveticaNeue-UltraLight", size: 17)!,
            NSParagraphStyleAttributeName:NSMutableParagraphStyle().copy()]
        if let userName = self.userName {
            userName.drawInRect(CGRect(x: 66 , y: 8, width: SupportFunction.getScreenWidth() - 66 - 8, height: 25), withAttributes: attributes)
        }
        if let context = self.context {
            context.drawInRect(CGRect(x: 66 , y: 66, width: SupportFunction.getScreenWidth() - 110, height: context.stringHeightWith(17, width: SupportFunction.getScreenWidth() -  110)), withAttributes: attributes)
        }
    }
    
    
    
    
    func clearSubLayers(){
        if self.layer.sublayers?.count > 2 {
            self.layer.sublayers = [self.layer.sublayers![0],self.layer.sublayers![1]]
        }
    }
    
    
    
    
    
    
    
   /* func drawUserPic(imgUrl:String, pic_Cache:[String:String], delegate:pic_CacheDegelate, saveImageQueue: dispatch_queue_t, img_Cache:[String:CGImage]) {
        let userImgLayer = CALayer()
        userImgLayer.contentsScale = UIScreen.mainScreen().scale
        userImgLayer.frame = CGRect(x: 8, y: 8, width: 50, height: 50)
        userImgLayer.cornerRadius = 25
        userImgLayer.masksToBounds = true
        //NetworkRequest.addImageLayerToView(userImgLayer, view: self, imgUrl: imgUrl, cache: pic_Cache, delegate: delegate,saveImageQueue: saveImageQueue, img_Cache: img_Cache)
     //   userImgLayer.contents = NetworkRequest.loadPic(imgUrl, delegate: delegate, saveImageQueue: saveImageQueue)
        self.layer.addSublayer(userImgLayer)
        
    }
    
    func drawImage(imgUrl:String, pic_Cache:[String:String], delegate:pic_CacheDegelate, textHeight:CGFloat, saveImageQueue: dispatch_queue_t) {
        if imgUrl != "" {
            let imageLayer = CALayer()
            imageLayer.contentsScale = UIScreen.mainScreen().scale
            if let localPath = Cache.searchDataFromCache(imgUrl, cache: pic_Cache) where NSFileManager.defaultManager().fileExistsAtPath(localPath), let localPic = NSFileManager.defaultManager().contentsAtPath(localPath), let img = UIImage(data: localPic){
                imageLayer.frame = CGRect(x: 66, y: 66 + textHeight + 8 , width: 150 * img.size.width / img.size.height, height: 150)
                imageLayer.contents = img.CGImage
                self.layer.addSublayer(imageLayer)
                print("Cache")
            }else {
                let saveName = imgUrl.md5
                Alamofire.request(.GET, imgUrl).responseData({ (response) -> Void in
                    dispatch_async(saveImageQueue, { () -> Void in
                        if let img:NSData = response.result.value {
                            let savePath = NSHomeDirectory() + "/Documents/Pic_Cache/\(saveName).jpg" //地址加密
                            //加入字典
                            delegate.appendPic_Cache(imgUrl, value: savePath)
                            img.writeToFile(savePath, atomically: true)
                            if let image = UIImage(data: img) {
                                    if let saveData = UIImageJPEGRepresentation(image, 1.0){
                                        saveData.writeToFile(savePath, atomically: true)
                                    }
                                    imageLayer.frame  = CGRect(x: 66, y: 66 + textHeight + 8 , width: 150 * image.size.width/image.size.height, height: 150)
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        imageLayer.contents = image.CGImage
                                        self.layer.addSublayer(imageLayer)
                                        
                                    })
                                }
                            }
                    })
                    
                })
            }
        }
        
    }
    
*/
    func drawImageToLayer(image: CGImage, layer: CALayer) {
        if CGImageGetWidth(image) != 50 || CGImageGetHeight(image) != 50 {
            layer.frame.size = CGSizeMake(150 * CGFloat(CGImageGetWidth(image)) / CGFloat(CGImageGetHeight(image)), 150)
        }
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            layer.contents = image
            self.layer.addSublayer(layer)
        }
    }
    
    
    
    
    
    

    
}
