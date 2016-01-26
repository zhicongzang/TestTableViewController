//
//  PWeiboCell.swift
//  TestTableViewController
//
//  Created by Zhicong Zang on 12/16/15.
//  Copyright © 2015 Zhicong Zang. All rights reserved.
//

import UIKit



class PWeiboCell: UITableViewCell {
    
    var weiboData: WeiboData?
    var delegate: pic_CacheDegelate?
    var row: Int?
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        self.selectedBackgroundView = UIView(frame: self.frame)
        self.selectedBackgroundView?.backgroundColor = UIColor(white: 0.66, alpha: 0.1)
        self.multipleTouchEnabled = true
        
    }
    

    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selercted state
        
        
    }
    func getData(weiboData:WeiboData, delegate:pic_CacheDegelate) {
        self.weiboData = weiboData
        self.delegate = delegate
    }
    
    
    
    override func drawRect(rect: CGRect) {
        if let weiboData = self.weiboData, let delegate = self.delegate{
            if let fullImg = delegate.getFullImageByKey(weiboData.id) {
                let context = UIGraphicsGetCurrentContext()
                CGContextScaleCTM(context, 1, -1)
                CGContextDrawImage(context, CGRect(x:0, y:0, width:SupportFunction.getScreenWidth(),height: -weiboData.getHeight()), fullImg)
                print("\(row!): from Cache")
            }else if let fullImg = SupportFunction.createImageWithWeiboData(weiboData, delegate: delegate) {
                let context = UIGraphicsGetCurrentContext()
                CGContextScaleCTM(context, 1, -1)
                CGContextDrawImage(context, CGRect(x:0, y:0, width:SupportFunction.getScreenWidth(),height: -weiboData.getHeight()), fullImg)
                print("\(row!): create full Pic")
            }else {
                let  attributes = [NSFontAttributeName:UIFont(name: fontName, size: fontSize)!,
                NSParagraphStyleAttributeName:NSMutableParagraphStyle().copy()]
                let textHeight = weiboData.text.stringHeightWith(17, width: SupportFunction.getScreenWidth() -  110)
                let userName = weiboData.user.name
                userName.drawInRect(CGRect(x: 66 , y: 8, width: SupportFunction.getScreenWidth() - 66 - 8, height: 25), withAttributes: attributes)
                let text = weiboData.text
                text.heightLightString([StringSearchingOptions.WeiboURL,StringSearchingOptions.WeiboUserName,StringSearchingOptions.WeiboHot]).drawInRect(CGRect(x: 66 , y: 66, width: SupportFunction.getScreenWidth() - 110, height: textHeight))
                
                let context = UIGraphicsGetCurrentContext()
                
                CGContextScaleCTM(context, 1, -1)
                let userPicUrl = weiboData.user.profileImgUrl
                if let userPic = delegate.getImageByKey(userPicUrl) {
                    CGContextDrawImage(context, CGRect(x: 8, y: -8, width: 50, height: -50), userPic)
                }else if let userPic = UIImage(named: "1.jpg")?.circleImage().CGImage {
                    CGContextDrawImage(context, CGRect(x: 8, y: -8, width: 50, height: -50),userPic)
                }
                let smallPicUrl = weiboData.smallPicUrl
                if smallPicUrl != "" {
                    if let pic = delegate.getImageByKey(smallPicUrl) {
                        CGContextDrawImage(context, CGRect(x: 66, y: -(66 + textHeight + 8), width: 150 * CGFloat(CGImageGetWidth(pic)) / CGFloat(CGImageGetHeight(pic)), height: -150), pic)
                    }else if let pic = UIImage(named: "2.jpg")?.CGImage {
                        CGContextDrawImage(context, CGRect(x: 66, y: -(66 + textHeight + 8), width: 150 * CGFloat(CGImageGetWidth(pic)) / CGFloat(CGImageGetHeight(pic)), height: -150), pic)
                    }
                    CGContextDrawImage(context, CGRect(x: 0, y: -(66 + textHeight + 8 + 150 + 8), width: SupportFunction.getScreenWidth(), height: -38), lineImage.CGImage)
                    
                }else {
                    CGContextDrawImage(context, CGRect(x: 0, y: -(66 + textHeight + 8), width: SupportFunction.getScreenWidth(), height: -38), lineImage.CGImage)
                }
                
                print("\(row!): Draw!")
                setNeedsDisplay()
                
                
            }
            
            
            
        }
        
    }
    
    
    
    
}
