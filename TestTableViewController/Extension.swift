//
//  Extension.swift
//  TestTableViewController
//
//  Created by Zhicong Zang on 12/11/15.
//  Copyright © 2015 Zhicong Zang. All rights reserved.
//

import Foundation
import UIKit

enum StringSearchingOptions: String {
    case WeiboURL = "https?://t.cn/[a-z0-9]{7}"
    case WeiboUserName = "@[\\-_\\.a-z0-9\\u4e00-\\u9fa5]{1,50} "
    case WeiboHot = "#[\\-_\\.a-z0-9\\u4e00-\\u9fa5]{1,50}#"
}

extension String {
    
    func stringHeightWith(fontSize:CGFloat,width:CGFloat) -> CGFloat {
        let font = UIFont(name: "HelveticaNeue-UltraLight", size: 17)!
        let size = CGSizeMake(width,CGFloat.max)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping;
        let  attributes = [NSFontAttributeName:font,
            NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        let text = self as NSString
        let rect = text.boundingRectWithSize(size, options:.UsesLineFragmentOrigin, attributes: attributes, context:nil)
        return CGFloat(Int(rect.size.height / 19.448) * 20)
    }
    
    var md5: String {
        let string = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let stringLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(string!, stringLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.destroy()
        return hash as String
        
    }
    
    func heightLightString(options: [StringSearchingOptions]) -> NSAttributedString {
        let attrSting = NSMutableAttributedString(string: self)
        attrSting.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-UltraLight", size: 17)!, range: NSMakeRange(0,self.characters.count))
        for option in options {
            if let regex = try? NSRegularExpression(pattern: option.rawValue, options: NSRegularExpressionOptions.CaseInsensitive) {
                let matches = regex.matchesInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0,self.characters.count))
                for match in matches {
                    
                    attrSting.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: match.range)
                }
            }
        }
        
        
        return attrSting
    }
}



extension UIView {
    
    func setHeight(height: CGFloat) {
        var rect:CGRect = self.frame
        rect.size.height = height
        self.frame = rect
    }
    
    func setWidth(width: CGFloat) {
        var rect:CGRect = self.frame
        rect.size.width = width
        self.frame = rect
    }
    
    
}


extension UIImage {
    func circleImage() -> UIImage{
        UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2)
        CGContextSetStrokeColorWithColor(context, UIColor(white: 0.66, alpha: 0.1).CGColor)
        let rect = CGRectMake(0, 0, self.size.width, self.size.height)
        CGContextAddEllipseInRect(context, rect)
        CGContextClip(context)
        
        self.drawInRect(rect)
        CGContextAddEllipseInRect(context, rect)
        CGContextStrokePath(context)
        let new = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return new

    }

    
}
