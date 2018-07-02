// WisOpt copyright Monkwish 2017

import Foundation
import ObjectMapper

class Announcements: Mappable {

    //MARK: Properties
    var messageId: Int?
    var groupId: Int?
    var message: String?
    var type: String?
    var time: String?
    var createdTime: String?
    var name: String?
    var gender: String?
    var unreadCount = 0

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        messageId <- map["a_m_id"]
        groupId <- map["a_group_id"]
        message <- map["a_message"]
        type <- map["a_type"]
        time <- map["a_time"]
        createdTime <- map["a_m_created_at"]
        name <- map["name"]
        gender <- map["gender"]

    }
}
