//
//  Extension.swift
//  TestTableViewController
//
//  Created by Zhicong Zang on 12/11/15.
//  Copyright © 2015 Zhicong Zang. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    //字体需要修改
    func stringHeightWith(fontSize:CGFloat,width:CGFloat)->CGFloat {
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
