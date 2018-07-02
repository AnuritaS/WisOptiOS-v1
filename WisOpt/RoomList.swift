// WisOpt copyright Monkwish 2017

import Foundation
import ObjectMapper

class RoomList: Mappable {

    var status: String?
    var rooms: [Room]?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        status <- map["status"]
        rooms <- map["rooms"]
    }
}
