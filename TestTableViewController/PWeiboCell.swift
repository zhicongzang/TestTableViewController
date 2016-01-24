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
    
    
  /*  func drawCell(data:WeiboData, delegate: pic_CacheDegelate, saveImageQueue: dispatch_queue_t) {
        clearSubLayers()
        NetworkRequest.loadPic(data.user.profileImgUrl, delegate: delegate, saveImageQueue: saveImageQueue, completed: { (image) -> Void in
            let layer = CALayer()
            layer.contentsScale = UIScreen.mainScreen().scale
            layer.frame = CGRect(x: 8, y: 8, width: 50, height: 50)
            layer.cornerRadius = 25
            layer.masksToBounds = true
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                layer.contents = image
                self.layer.addSublayer(layer)
            }
        })
        NetworkRequest.loadPic(data.smallPicUrl, delegate: delegate, saveImageQueue: saveImageQueue) { (image) -> Void in
            let layer = CALayer()
            layer.contentsScale = UIScreen.mainScreen().scale
            layer.frame = CGRect(x: 66, y: 66 + data.text.stringHeightWith(17, width: SupportFunction.getScreenWidth() -  110) + 8 , width: 150 * CGFloat(CGImageGetWidth(image)) / CGFloat(CGImageGetHeight(image)), height: 150)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                layer.contents = image
                self.layer.addSublayer(layer)
            })
        }
    }
    
 */
    
    override func drawRect(rect: CGRect) {
        
        
        let  attributes = [NSFontAttributeName:UIFont(name: "HelveticaNeue-UltraLight", size: 17)!,
            NSParagraphStyleAttributeName:NSMutableParagraphStyle().copy()]
        if let userName = self.userName {
            userName.drawInRect(CGRect(x: 66 , y: 8, width: SupportFunction.getScreenWidth() - 66 - 8, height: 25), withAttributes: attributes)
        }
        if let context = self.context {
            //context.drawInRect(CGRect(x: 66 , y: 66, width: SupportFunction.getScreenWidth() - 110, height: context.stringHeightWith(17, width: SupportFunction.getScreenWidth() -  110)), withAttributes: attributes)
            context.heightLightString([StringSearchingOptions.WeiboURL,StringSearchingOptions.WeiboUserName,StringSearchingOptions.WeiboHot]).drawInRect(CGRect(x: 66 , y: 66, width: SupportFunction.getScreenWidth() - 110, height: context.stringHeightWith(17, width: SupportFunction.getScreenWidth() -  110)))
        }
        let context = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(context, 1, -1);
        CGContextDrawImage(context, CGRect(x: 8, y: -8, width: 50, height: -50), delegate!.getImageByKey(userPicUrl!))
        CGContextDrawImage(context, CGRect(x: 66, y: -(66 + self.context!.stringHeightWith(17, width: SupportFunction.getScreenWidth() -  110) + 8 ), width: 150 * CGFloat(CGImageGetWidth(delegate!.getImageByKey(smallPicUrl!))) / CGFloat(CGImageGetHeight(delegate!.getImageByKey(smallPicUrl!))), height: -150), delegate!.getImageByKey(smallPicUrl!))
        
        
    }
    

    
    func clearSubLayers(){
        if self.layer.sublayers?.count > 2 {
            self.layer.sublayers = [self.layer.sublayers![0],self.layer.sublayers![1]]
        }
    }
    
    
}
