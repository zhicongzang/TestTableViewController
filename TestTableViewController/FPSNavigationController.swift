//
//  FPSNavigationController.swift
//  TestTableViewController
//
//  Created by Zhicong Zang on 1/6/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class FPSNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fpsLabel = FPSLabel(x: 0, y: 20)
        fpsLabel.enablePrint = false
        self.view.addSubview(fpsLabel)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
