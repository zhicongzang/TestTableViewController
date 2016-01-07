//
//  FPSLabel.swift
//  TestTableViewController
//
//  Created by Zhicong Zang on 1/6/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit


let kSize = CGSizeMake(70, 20)

class FPSLabel: UILabel{
    var enablePrint = false
    var lastTime = NSTimeInterval()
    var count = 0
    
    init(x: CGFloat, y: CGFloat) {
        let frame = CGRect(x: x, y: y, width: kSize.width, height: kSize.height)
        super.init(frame: frame)
        let link = CADisplayLink(target: self, selector: "tick:")
        link.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        self.backgroundColor = UIColor(white: 1, alpha: 0.2)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.textAlignment = .Center
        self.font = UIFont(name: "Courier", size: 14)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tick(link:CADisplayLink) {
        if lastTime == 0{
            lastTime = link.timestamp
        }
        count++
        
        if link.timestamp - lastTime >= 1 {
            lastTime = link.timestamp
            if enablePrint {
                print("FPS: \(count)")
            }
            self.text = "FPS: \(count)"
            count = 0
        }
    }
}



