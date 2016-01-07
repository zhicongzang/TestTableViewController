//
//  PWeiboCell.swift
//  TestTableViewController
//
//  Created by Zhicong Zang on 12/16/15.
//  Copyright © 2015 Zhicong Zang. All rights reserved.
//

import UIKit
import Alamofire

class PWeiboCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit{
        self.layer.sublayers = nil
    }
    
    func drawCell(data: WeiboData, pic_Cache:[String:String], delegate: pic_CacheDegelate) {
        clearSubLayers()
        let textHeight = data.text.stringHeightWith(17, width: SupportFunction.getScreenWidth() -  110)
        drawUserName(data.user.name)
        drawUserPic(data.user.profileImgUrl, pic_Cache: pic_Cache, delegate: delegate)
        drawText(data.text, textHeight: textHeight)
        drawImage(data.smallPicUrl, pic_Cache: pic_Cache, delegate: delegate, textHeight: textHeight)
    }
    
    func clearSubLayers(){
        if self.layer.sublayers?.count > 2 {
            self.layer.sublayers = [self.layer.sublayers![0],self.layer.sublayers![1]]
        }
    }
    
    func drawUserName(user:String) {
        let textLayer = CATextLayer()
        //字体问题
        textLayer.font = CTFontCreateWithName(UIFont.systemFontOfSize(17).fontName as CFStringRef, UIFont.systemFontOfSize(17).pointSize as CGFloat, nil)
        textLayer.frame = CGRect(x: 66 , y: 8, width: SupportFunction.getScreenWidth() - 66 - 8, height: 25)
        textLayer.fontSize = UIFont.systemFontOfSize(17).pointSize as CGFloat
        textLayer.string = user
        textLayer.wrapped = true
        textLayer.foregroundColor = UIColor.blackColor().CGColor
        textLayer.contentsScale = UIScreen.mainScreen().scale
        self.layer.addSublayer(textLayer)
    }
    
    func drawUserPic(imgUrl:String, pic_Cache:[String:String], delegate:pic_CacheDegelate) {
        let userImgLayer = CALayer()
        userImgLayer.contentsScale = UIScreen.mainScreen().scale
        userImgLayer.frame = CGRect(x: 8, y: 8, width: 50, height: 50)
        userImgLayer.cornerRadius = 25
        userImgLayer.masksToBounds = true
        NetworkRequest.addImageLayerToView(userImgLayer, view: self, imgUrl: imgUrl, cache: pic_Cache, delegate: delegate)
        
    }
    
    func drawText(text:String, textHeight:CGFloat) {
        
        
        let textLayer = CATextLayer()
        //字体问题
        
        let font = UIFont(name: "HelveticaNeue-UltraLight", size: 17)!
        
        //textLayer.font = CGFontCreateWithFontName(UIFont.systemFontOfSize(17).fontName as CFStringRef)
        textLayer.font = CGFontCreateWithFontName(font.fontName as CFStringRef)
        textLayer.frame = CGRect(x: 66 , y: 66, width: SupportFunction.getScreenWidth() - 110, height: textHeight)
        textLayer.alignmentMode = kCAAlignmentJustified
        textLayer.fontSize = font.pointSize as CGFloat
        
        
        textLayer.string = text
        textLayer.wrapped = true
        textLayer.foregroundColor = UIColor.blackColor().CGColor
        textLayer.contentsScale = UIScreen.mainScreen().scale
        
        
        
        self.layer.addSublayer(textLayer)
        
    }
    
    func drawImage(imgUrl:String, pic_Cache:[String:String], delegate:pic_CacheDegelate, textHeight:CGFloat) {
        if imgUrl != "" {
            let imageLayer = CALayer()
            imageLayer.contentsScale = UIScreen.mainScreen().scale
            if let localPath = Cache.searchDataFromCache(imgUrl, cache: pic_Cache) where NSFileManager.defaultManager().fileExistsAtPath(localPath), let localPic = NSFileManager.defaultManager().contentsAtPath(localPath), let img = UIImage(data: localPic){
                imageLayer.frame = CGRect(x: 66, y: 66 + textHeight + 8 , width: img.size.width, height: img.size.height)
                imageLayer.contents = img.CGImage
                self.layer.addSublayer(imageLayer)
            }else {
                let saveName = imgUrl.md5
                Alamofire.request(.GET, imgUrl).responseData({ (response) -> Void in
                    if let img:NSData = response.result.value {
                        let savePath = NSHomeDirectory() + "/Documents/Pic_Cache/\(saveName).jpg" //地址加密
                        //加入字典
                        delegate.appendPic_Cache(imgUrl, value: savePath)
                            img.writeToFile(savePath, atomically: true)
                            if let image = UIImage(data: img) {
                                if let imageScaled = UIImage(data: img, scale: image.size.height/150){
                                    if let saveData = UIImageJPEGRepresentation(imageScaled, 1.0){
                                        saveData.writeToFile(savePath, atomically: true)
                                    }
                                    imageLayer.frame  = CGRect(x: 66, y: 66 + textHeight + 8 , width: imageScaled.size.width, height: imageScaled.size.height)
                                    imageLayer.contents = imageScaled.CGImage
                                    self.layer.addSublayer(imageLayer)
                                }
                            }
                    }
                })
            }
        }
        
    }

    
    
}
