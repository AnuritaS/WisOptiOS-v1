// WisOpt copyright Monkwish 2017

import Foundation
import ObjectMapper

class RoomDetail: Mappable {

    var dId: String?
    var program: String?
    var semester: Int?
    var courseCodeTitle: String?
    var courseTitle: String?
    var offeringDepartment: String?
    var slot: String?
    var facultyId: String?
    var facultyName: String?
    var mobile: String?
    var officialEmail: String?
    var offeredTo: String?
    var labSlot: String?
    var classRoom: String?
    var block: String?
    var tId: String?
    var classFrom: String?
    var classTo: String?
    var tDayOrder: String?
    var tSlot: String?
    var batch: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        dId <- map["d_id"]
        program <- map["Program"]
        semester <- map["Semester"]
        courseCodeTitle <- map["Course_Code_Title"]
        courseTitle <- map["Course_Title"]
        offeringDepartment <- map["Offering_Department"]
        slot <- map["Slot"]
        facultyId <- map["Faculty_ID"]
        facultyName <- map["Faculty_Name"]
        mobile <- map["Mobile_No"]
        officialEmail <- map["Official_Email"]
        offeredTo <- map["Offered_To"]
        labSlot <- map["Lab_Slots"]
        classRoom <- map["Class_Room"]
        block <- map["Block"]
        tId <- map["t_id"]
        classFrom <- map["class_from"]
        classTo <- map["class_to"]
        tDayOrder <- map["t_day_order"]
        tSlot <- map["t_slot"]
        batch <- map["Batch"]
    }
}
