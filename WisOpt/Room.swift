// WisOpt copyright Monkwish 2017

import Foundation
import ObjectMapper

class Room: Mappable {

    var room: String?
    var classFrom: String?
    var classTo: String?
    var dayOrder: String?
    var block: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        room <- map["room"]
        classFrom <- map["class_from"]
        classTo <- map["class_to"]
        dayOrder <- map["day_order"]
        block <- map["block"]
    }
}
