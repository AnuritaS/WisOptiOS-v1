// WisOpt copyright Monkwish 2017

import Foundation
import ObjectMapper


class GetAnnouncements: Mappable {

    var messages: [Announcements]?
    var reply_count: [Reply_count]?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        messages <- map["Announcements"]
        reply_count <- map["reply_count"]
    }
}
