//
//  WeiboData.swift
//  WeiboTest
//
//  Created by Zhicong Zang on 12/8/15.
//  Copyright © 2015 Zhicong Zang. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

struct WeiboData {
    let createdTime: String
    let id: Int
    let idStr: String
    let text: String
    let smallPicUrl: String
    let bigPicUrl: String
    let user: UserData
    let reposts_count: Int
    let comments_count: Int
    let attitudes_count: Int
    init(data:JSON){
        self.createdTime = data["created_at"].stringValue
        self.id = data["id"].intValue
        self.idStr = data["idstr"].stringValue
        self.text = data["text"].stringValue
        self.smallPicUrl = data["thumbnail_pic"].stringValue
        self.bigPicUrl = data["original_pic"].stringValue
        self.user = UserData(data: data["user"])
        self.reposts_count = data["reposts_count"].intValue
        self.comments_count = data["comments_count"].intValue
        self.attitudes_count = data["attitudes_count"].intValue
    }
}

struct UserData {
    let name: String
    let profileImgUrl: String
    init(data:JSON){
        self.name = data["screen_name"].stringValue
        self.profileImgUrl = data["profile_image_url"].stringValue
    }
}
