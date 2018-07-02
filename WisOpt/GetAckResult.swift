// WisOpt copyright Monkwish 2017

import Foundation
import ObjectMapper

class GetAckResult: Mappable {

    var status: String?
    var readMem: [MemberA]?
    var unreadMem: [MemberA]?
    var readC: Int?
    var totalC: Int?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        status <- map["status"]
        readMem <- map["read"]
        unreadMem <- map["unread"]
        readC <- map["readCount"]
        totalC <- map["totalmember"]
    }
}

class MemberA: Mappable {

    var id: Int?
    var name: String?
    var regId: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        //print(map)
        id <- map["id"]
        name <- map["name"]
        regId <- map["reg_id"]
    }
}

