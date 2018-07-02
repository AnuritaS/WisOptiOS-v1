// WisOpt copyright Monkwish 2017

import Foundation
import ObjectMapper

class ReplyResult: Mappable {

    var replies: [Reply]?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        replies <- map["reply"]
    }
}
