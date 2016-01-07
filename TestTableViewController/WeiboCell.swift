//
//  WeiboCell.swift
//  TestTableViewController
//
//  Created by Zhicong Zang on 12/10/15.
//  Copyright © 2015 Zhicong Zang. All rights reserved.
//

import UIKit
import Alamofire

class WeiboCell: UITableViewCell {
    
    @IBOutlet weak var user_Pic: UIImageView!
    @IBOutlet weak var user_Name: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentImg: UIImageView!
    @IBOutlet weak var reposts_count: UILabel!
    @IBOutlet weak var comments_count: UILabel!
    @IBOutlet weak var attitudes_count: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        user_Pic.layer.cornerRadius = user_Pic.layer.bounds.width / 2
        user_Pic.layer.masksToBounds = true
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setWeiboData(data: WeiboData, pic_Cache:[String:String], delegate: pic_CacheDegelate) {
        user_Name.text = data.user.name
        NetworkRequest.fillUIImageWithImageUrl(user_Pic, imgUrl: data.user.profileImgUrl, cache: pic_Cache, delegate: delegate)
        let content = data.text
        let contentLabelHeight = content.stringHeightWith(17, width: SupportFunction.getScreenWidth() - 55 * 2)
        contentLabel.setHeight(contentLabelHeight)
        contentLabel.text = content
        NetworkRequest.fillUIImageWithImageUrl(contentImg, imgUrl: data.smallPicUrl, cache: pic_Cache, delegate: delegate)
        reposts_count.text = "\(data.reposts_count)"
        comments_count.text = "\(data.comments_count)"
        attitudes_count.text = "\(data.attitudes_count)"
       
    }
    
    
    class func cellHeightByData(data:WeiboData) -> CGFloat{
        return 8 + 50 + 8 + data.text.stringHeightWith(17, width: SupportFunction.getScreenWidth() - 55 * 2) + 8 + 28 + 20
    }
    
}
