// WisOpt copyright Monkwish 2017

import Foundation
import ObjectMapper

class ServerResult: Mappable {

    var status: String?
    var userData: User?
    var userDetail: Detail?
    var roomDetails: RoomDetail?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        status <- map["status"]
        userData <- map["UserData"]
        roomDetails <- map["Details"]
        userDetail <- map["details"]
    }
}
