// WisOpt copyright Monkwish 2017

import Foundation
import ObjectMapper

class Reply: Mappable {

    var replyId: Int?
    var messageId: Int?
    var message: String?
    var time: String?
    var userId: Int?
    var name: String?
    var gender: String?
    var profession: String?

    var r_type: String?
    var reply_s_time: String?
    var reg_id: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        replyId <- map["reply_id"]
        messageId <- map["a_id"]
        message <- map["reply_message"]
        time <- map["reply_time"]
        userId <- map["reply_user_id"]
        name <- map["name"]
        gender <- map["gender"]
        profession <- map["profession"]

        r_type <- map["r_type"]
        reply_s_time <- map["reply_s_time"]
        reg_id <- map["reg_id"]
    }
}
