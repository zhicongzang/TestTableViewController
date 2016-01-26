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
    
    var id: Int?
    var userName: String?
    var context: String?
    var delegate: pic_CacheDegelate?
    var userPicUrl: String?
    var smallPicUrl: String?
    
    
    
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
    
    
    
    override func drawRect(rect: CGRect) {
        
        if let id = self.id, let fullImg = delegate?.getFullImageByKey(id) {
            let context = UIGraphicsGetCurrentContext()
            CGContextScaleCTM(context, 1, -1)
            CGContextDrawImage(context, CGRect(x:0, y:0, width:CGFloat(CGImageGetWidth(fullImg)),height: -CGFloat(CGImageGetHeight(fullImg))), fullImg)
            print("\(userName!): use full img")
        }else {
            let  attributes = [NSFontAttributeName:UIFont(name: "HelveticaNeue-UltraLight", size: 17)!,
                NSParagraphStyleAttributeName:NSMutableParagraphStyle().copy()]
            let textHeight = self.context!.stringHeightWith(17, width: SupportFunction.getScreenWidth() -  110)
            if let userName = self.userName {
                userName.drawInRect(CGRect(x: 66 , y: 8, width: SupportFunction.getScreenWidth() - 66 - 8, height: 25), withAttributes: attributes)
            }
            if let text = self.context {
                text.heightLightString([StringSearchingOptions.WeiboURL,StringSearchingOptions.WeiboUserName,StringSearchingOptions.WeiboHot]).drawInRect(CGRect(x: 66 , y: 66, width: SupportFunction.getScreenWidth() - 110, height: textHeight))
            }
            
            
            if let delegate = self.delegate {
                let context = UIGraphicsGetCurrentContext()
                CGContextScaleCTM(context, 1, -1)
                if let userPicUrl = self.userPicUrl {
                    if let userPic = delegate.getImageByKey(userPicUrl) {
                        CGContextDrawImage(context, CGRect(x: 8, y: -8, width: 50, height: -50), userPic)
                    }else if let userPic = UIImage(named: "1.jpg")?.circleImage().CGImage {
                        CGContextDrawImage(context, CGRect(x: 8, y: -8, width: 50, height: -50),userPic)
                    }
                }
                
                if let smallPicUrl = self.smallPicUrl where smallPicUrl != "" {
                    if let pic = delegate.getImageByKey(smallPicUrl) {
                        CGContextDrawImage(context, CGRect(x: 66, y: -(66 + textHeight + 8), width: 150 * CGFloat(CGImageGetWidth(pic)) / CGFloat(CGImageGetHeight(pic)), height: -150), pic)
                    }else if let pic = UIImage(named: "2.jpg")?.CGImage {
                        CGContextDrawImage(context, CGRect(x: 66, y: -(66 + textHeight + 8), width: 150 * CGFloat(CGImageGetWidth(pic)) / CGFloat(CGImageGetHeight(pic)), height: -150), pic)
                    }
                    CGContextDrawImage(context, CGRect(x: 0, y: -(66 + textHeight + 8 + 150 + 8), width: lineImage.size.width, height: -lineImage.size.height), lineImage.CGImage)
                    
                }else {
                    CGContextDrawImage(context, CGRect(x: 0, y: -(66 + textHeight + 8), width: lineImage.size.width, height: -lineImage.size.height), lineImage.CGImage)
                }
                
            }
            /*
            UIColor(white: 0.66, alpha: 1).set()
            CGContextSetLineWidth(context, 0.4)
            CGContextMoveToPoint(context, 0, -(66 + textHeight + 8 + 0.4/2))
            CGContextAddLineToPoint(context, SupportFunction.getScreenWidth(), -(66 + textHeight + 8))
            CGContextStrokePath(context)
            CGContextMoveToPoint(context, 0, -(66 + textHeight + 8  - 0.4/2 + 28))
            CGContextAddLineToPoint(context, SupportFunction.getScreenWidth(), -(66 + textHeight + 8  - 0.4/2 + 28))
            CGContextStrokePath(context)
            CGContextMoveToPoint(context, SupportFunction.getScreenWidth()/3, -(66 + textHeight + 8 + 0.4/2))
            CGContextAddLineToPoint(context, SupportFunction.getScreenWidth()/3, -(66 + textHeight + 8  - 0.4/2 + 28))
            CGContextStrokePath(context)
            CGContextMoveToPoint(context, 2 * SupportFunction.getScreenWidth()/3, -(66 + textHeight + 8 + 0.4/2))
            CGContextAddLineToPoint(context, 2 * SupportFunction.getScreenWidth()/3, -(66 + textHeight + 8  - 0.4/2 + 28))
            CGContextStrokePath(context)
            UIColor(white: 0.66, alpha: 0.3).set()
            CGContextSetLineWidth(context, 10)
            CGContextMoveToPoint(context, 0, -(66 + textHeight + 8 + 28 + 10/2))
            CGContextAddLineToPoint(context, SupportFunction.getScreenWidth(), -(66 + textHeight + 8 + 28 + 10/2))
            CGContextStrokePath(context)
            */
        }
        
    }
    
    
    
    func clearSubLayers(){
        if self.layer.sublayers?.count > 2 {
            self.layer.sublayers = [self.layer.sublayers![0],self.layer.sublayers![1]]
        }
    }
    
    
}
