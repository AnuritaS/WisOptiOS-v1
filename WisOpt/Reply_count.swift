//
//  Reply_count.swift
//  WisOpt
//
//  Created by WisOpt on 18/01/18.
//  Copyright © 2018 MonkWish Production. All rights reserved.
//

import Foundation
import ObjectMapper

class Reply_count: Mappable {


    var reply_on_ann: Int?
    var count: Int?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        reply_on_ann <- map["reply_on_ann"]
        count <- map["count_unread"]
    }
}
