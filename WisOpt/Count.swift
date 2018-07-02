// WisOpt copyright Monkwish 2017

import Foundation
import ObjectMapper

class Count: Mappable {
    var groupId: Int?
    var count: Int?
    var last_time: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        groupId <- map["groupId"]
        count <- map["unread_count"]
        last_time <- map["last_time"]
    }
}

class ReplyCount: Mappable {
    var reply_s: Int?
    var a_group_id: Int?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        reply_s <- map["reply_s"]
        a_group_id <- map["a_group_id"]
    }
}
