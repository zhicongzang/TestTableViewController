//
//  Cache.swift
//  TestTableViewController
//
//  Created by Zhicong Zang on 12/14/15.
//  Copyright © 2015 Zhicong Zang. All rights reserved.
//

import Foundation

class Cache {
    class func searchDataFromCache<E>(key: String, cache: [String: E]) -> E?{
        return cache[key]
    }
}