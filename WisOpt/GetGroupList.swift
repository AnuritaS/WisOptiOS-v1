// WisOpt copyright Monkwish 2017

import Foundation
import ObjectMapper

class GetGroupList: Mappable {
    var groups: [Group]?
    var counts: [Count]?
    var replyCount: [ReplyCount]?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        groups <- map["all"]
        counts <- map["count"]
        replyCount <- map["reply"]
    }
}
