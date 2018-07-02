// WisOpt copyright Monkwish 2017

import Foundation
import ObjectMapper

class Group: Mappable {
    var groupId: Int?
    var groupAdmin: Int?
    var subjectCode: String?
    var subjectName: String?
    var groupBarcode: String?
    var groupCode: String?
    var createdTime: String?
    var adminName: String?
    var adminRegId: String?
    var gender: String?
    var profession: String?

    var count: Int = 0
    var replyCount: Int = 0
    var lastTime: Date = Date()

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        groupId <- map["groupId"]
        groupAdmin <- map["group_admin"]
        subjectCode <- map["subject_code"]
        subjectName <- map["subject_name"]
        groupBarcode <- map["group_barcode"]
        groupCode <- map["group_code"]
        createdTime <- map["created_time"]
        adminName <- map["admin_name"]
        adminRegId <- map["admin_reg_id"]
        gender <- map["admin_gender"]
        profession <- map["admin_profession"]
    }

    func setCount(c: Int) {
        self.count = c
    }

    func setReplyCount(r: Int) {
        self.replyCount = r
    }

    func setLastTime(t: Date) {
        self.lastTime = t
    }
}
